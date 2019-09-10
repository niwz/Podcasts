//
//  PodcastsSearchController.swift
//  Podcasts
//
//  Created by Nicholas Wong on 9/6/19.
//  Copyright © 2019 Nicholas Wong. All rights reserved.
//

import UIKit
import Alamofire

class PodcastsSearchController: UIViewController, UISearchBarDelegate {

    let tableView = UITableView()
    let searchController = UISearchController(searchResultsController: nil)
    let cellId = "cellId"
    var podcasts = [Podcast]()
    var timer: Timer?
    let activityIndicatorView: UIActivityIndicatorView = {
        let activityIndicatorView = UIActivityIndicatorView(style: .whiteLarge)
        activityIndicatorView.color = .black
        return activityIndicatorView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        setupSearchController()
        setupTableView()
        setupActivityIndicatorView()
    }

    //MARK:- Search Bar
    private func setupSearchController() {
        navigationItem.searchController = searchController
        navigationItem.hidesSearchBarWhenScrolling = false
        searchController.dimsBackgroundDuringPresentation = false
        searchController.searchBar.delegate = self
        definesPresentationContext = true
    }

    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        timer?.invalidate()
        timer = Timer.scheduledTimer(withTimeInterval: 0.5, repeats: false, block: { (_) in
            self.activityIndicatorView.startAnimating()
            self.fetchPodcasts(searchText)
        })
    }

    private func fetchPodcasts(_ searchText: String) {
        Service.shared.fetchPodcasts(searchText) { (podcasts) in
            self.podcasts = podcasts
            self.tableView.reloadData()
            self.activityIndicatorView.stopAnimating()
        }
    }

    //MARK:- TableView
    private func setupTableView() {
        view.addSubview(tableView)
        tableView.frame = view.frame
        tableView.dataSource = self
        tableView.delegate = self
        tableView.tableFooterView = UIView()
        tableView.register(PodcastCell.self, forCellReuseIdentifier: cellId)
    }

    private func setupActivityIndicatorView() {
        view.addSubview(activityIndicatorView)
        activityIndicatorView.frame = view.frame
    }
}

extension PodcastsSearchController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let label = UILabel()
        label.text = "Please enter a search term."
        label.textColor = .purple
        label.font = .systemFont(ofSize: 20, weight: .semibold)
        label.textAlignment = .center
        return label
    }

    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return podcasts.count > 0 ? 0 : 250
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return podcasts.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath) as! PodcastCell
        let podcast = podcasts[indexPath.row]
        cell.podcast = podcast
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let episodesController = EpisodesController()
        let podcast = podcasts[indexPath.row]
        episodesController.podcast = podcast
        navigationController?.pushViewController(episodesController, animated: true)
    }
}
