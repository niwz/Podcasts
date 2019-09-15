//
//  EpisodesController.swift
//  Podcasts
//
//  Created by Nicholas Wong on 9/7/19.
//  Copyright © 2019 Nicholas Wong. All rights reserved.
//

import UIKit
import Stevia

class EpisodesController: UITableViewController {

    var episodes = [Episode]()
    var podcast: Podcast! {
        didSet {
            navigationItem.title = podcast.trackName
            fetchEpisodes()
        }
    }

    let activityIndicatorView: UIActivityIndicatorView = {
        let activityIndicatorView = UIActivityIndicatorView(style: .whiteLarge)
        activityIndicatorView.color = .black
        activityIndicatorView.startAnimating()
        return activityIndicatorView
    }()

    private let cellId = "cellId"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.register(EpisodeCell.self, forCellReuseIdentifier: cellId)
        tableView.tableFooterView = UIView()
        setupNavigationBarItems()
    }

    private func setupNavigationBarItems() {
        let savedPodcasts = UserDefaults.standard.savedPodcasts()
        let hasFavorited = savedPodcasts.firstIndex(where: { $0.trackName == podcast.trackName && $0.artistName == podcast.artistName }) != nil
        if hasFavorited {
            navigationItem.rightBarButtonItem = UIBarButtonItem(image: #imageLiteral(resourceName: "heart"), style: .plain, target: nil, action: nil)
        } else {
            navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Favorite", style: .plain, target: self, action: #selector(handleSaveFavorite))
        }
    }

    @objc func handleSaveFavorite() {
        print("Saving podcast.")
        if let podcast = podcast {
            do{
                var podcasts = UserDefaults.standard.savedPodcasts()
                podcasts.append(podcast)
                podcasts = Array(NSOrderedSet(array: podcasts)) as! [Podcast]
                let data = try JSONEncoder().encode(podcasts)
                UserDefaults.standard.set(data, forKey: UserDefaults.savedPodcastsKey)
                navigationItem.rightBarButtonItem = UIBarButtonItem(image: #imageLiteral(resourceName: "heart"), style: .plain, target: nil, action: nil)
                showBadgeHighlight()
            } catch let encodeError {
                print("Failed to save podcast: Error: \(encodeError)")
            }
        }
    }

    private func showBadgeHighlight() {
        UIApplication.mainTabBarController()?.viewControllers?[1].tabBarItem.badgeValue = "New"
    }

    private func fetchEpisodes() {
        guard let feedUrl = podcast?.feedUrl else { return }
        Service.shared.fetchEpisodes(feedUrl) { episodes in
            self.episodes = episodes
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }

    override func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return activityIndicatorView
    }

    override func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return episodes.isEmpty ? 250 : 0
    }

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
        guard let mainTabController = UIApplication.shared.keyWindow?.rootViewController as? MainTabBarController else { return }
        let playerView = mainTabController.playerDetailView
        let episode = episodes[indexPath.row]
        playerView.episode = episode
        mainTabController.maximizePlayer()
    }
}
