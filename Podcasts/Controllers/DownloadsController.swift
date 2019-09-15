
//
//  DownloadsController.swift
//  Podcasts
//
//  Created by Nicholas Wong on 9/14/19.
//  Copyright © 2019 Nicholas Wong. All rights reserved.
//

import UIKit

class DownloadsController: UITableViewController {

    private let cellId = "cellId"
    var episodes = UserDefaults.standard.downloadedEpisodes()

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.register(EpisodeCell.self, forCellReuseIdentifier: cellId)
        tableView.tableFooterView = UIView()
        setupObservers()
    }

    override func viewWillAppear(_ animated: Bool) {
        episodes = UserDefaults.standard.downloadedEpisodes()
        tableView.reloadData()
    }

    //MARK:- TableView Methods
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return episodes.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath) as! EpisodeCell
        let episode = episodes[indexPath.row]
        cell.episode = episode
        return cell
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let episode = episodes[indexPath.row]
        if episode.fileUrl != nil {
            guard let mainTabController = UIApplication.shared.keyWindow?.rootViewController as? MainTabBarController else { return }
            let playerView = mainTabController.playerDetailView
            playerView.episode = episode
            mainTabController.maximizePlayer()
        } else {
            let alertController = UIAlertController(title: "File not found.", message: nil, preferredStyle: .alert)
            let cancelAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
            alertController.addAction(cancelAction)
            present(alertController, animated: true)
        }
    }

    override func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        let deleteAction = UITableViewRowAction(style: .destructive, title: "Delete") { (_, indexPath) in
            self.episodes.remove(at: indexPath.row)
            self.tableView.deleteRows(at: [indexPath], with: .middle)
            do {
                let updatedEpisodesData = try JSONEncoder().encode(self.episodes)
                UserDefaults.standard.set(updatedEpisodesData, forKey: UserDefaults.downloadedEpisodesKey)
            } catch let updateError {
                print("Could not delete episode: ", updateError)
            }
        }
        return [deleteAction]
    }

    //MARK:- Observers
    private func setupObservers() {
        NotificationCenter.default.addObserver(self, selector: #selector(handleProgress), name: NSNotification.downloadProgress, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(handleDownloadComplete), name: NSNotification.downloadComplete, object: nil)
    }

    @objc private func handleProgress(notification: Notification) {
        guard let userInfo = notification.userInfo else { return }
        guard let title = userInfo["title"] as? String else { return }
        guard let progress = userInfo["progress"] as? Double else { return }
        guard let row = episodes.firstIndex(where: { $0.title == title }) else { return }
        guard let cell = tableView.cellForRow(at: IndexPath(row: row, section: 0)) as? EpisodeCell else { return }
        cell.progressLabel.isHidden = false
        cell.progressLabel.text = "\(Int(progress * 100))%"
        if progress == 1 {
            cell.progressLabel.isHidden = true
        }
    }

    @objc private func handleDownloadComplete(notification: Notification) {
        guard let episodeDownloadComplete = notification.object as? Service.EpisodeDownloadCompleteTuple else { return }
        guard let row = episodes.firstIndex(where: { $0.title == episodeDownloadComplete.episodeTitle }) else { return }
        episodes[row].fileUrl = episodeDownloadComplete.fileUrl
    }
}
