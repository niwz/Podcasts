//
//  FavoritesController.swift
//  Podcasts
//
//  Created by Nicholas Wong on 9/11/19.
//  Copyright © 2019 Nicholas Wong. All rights reserved.
//

import UIKit

class FavoritesController: UICollectionViewController, UICollectionViewDelegateFlowLayout {

    var podcasts = UserDefaults.standard.savedPodcasts()

    private let cellId = "cellId"

    override func viewDidLoad() {
        super.viewDidLoad()
        setupCollectionView()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        UIApplication.mainTabBarController()?.viewControllers?[1].tabBarItem.badgeValue = nil
        podcasts = UserDefaults.standard.savedPodcasts()
        collectionView.reloadData()
    }

    //MARK:- CollectionView Methods

    private func setupCollectionView() {
        collectionView.backgroundColor = .white
        collectionView.register(FavoritesCell.self, forCellWithReuseIdentifier: cellId)
        collectionView.contentInset = .init(top: 16, left: 16, bottom: 16, right: 16)
        let longPressRecognizer = UILongPressGestureRecognizer(target: self, action: #selector(handleLongPress))
        collectionView.addGestureRecognizer(longPressRecognizer)
    }

    @objc func handleLongPress(gesture: UILongPressGestureRecognizer) {
        let location = gesture.location(in: collectionView)
        guard let selectedIndexPath = collectionView.indexPathForItem(at: location) else { return }

        let alertController = UIAlertController(title: "Delete Podcast?", message: nil, preferredStyle: .actionSheet)
        alertController.addAction(UIAlertAction(title: "Delete", style: .destructive) { (_) in
            self.podcasts.remove(at: selectedIndexPath.item)
            self.collectionView.deleteItems(at: [selectedIndexPath])
            do {
                let updatedPodcastData = try JSONEncoder().encode(self.podcasts)
                UserDefaults.standard.set(updatedPodcastData, forKey: UserDefaults.savedPodcastsKey)
            } catch let updateError {
                print("Could not delete podcast: ", updateError)
            }
        })
        alertController.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        present(alertController, animated: true)
    }

    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return podcasts.count
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! FavoritesCell
        let podcast = podcasts[indexPath.item]
        cell.podcast = podcast
        return cell
    }

    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let episodesController = EpisodesController()
        let podcast = podcasts[indexPath.item]
        episodesController.podcast = podcast
        navigationController?.pushViewController(episodesController, animated: true)
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let spacing: CGFloat = 16 * 3
        let cellSize = (view.frame.width - spacing) / 2
        return .init(width: cellSize, height: cellSize + 46)
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 16
    }
}
