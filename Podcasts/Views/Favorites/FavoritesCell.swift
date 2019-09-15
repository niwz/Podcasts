//
//  FavoritesCell.swift
//  Podcasts
//
//  Created by Nicholas Wong on 9/13/19.
//  Copyright © 2019 Nicholas Wong. All rights reserved.
//

import UIKit
import Stevia

class FavoritesCell: UICollectionViewCell {

    var podcast: Podcast!{
        didSet {
            let imageUrl = URL(string: podcast.artworkUrl600 ?? "")
            imageView.sd_setImage(with: imageUrl)
            titleLabel.text = podcast.trackName
            artistLabel.text = podcast.artistName
        }
    }

    let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = #imageLiteral(resourceName: "appicon")
        imageView.clipsToBounds = true
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()

    let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "PODCAST TITLE"
        label.font = .boldSystemFont(ofSize: 15)
        return label
    }()

    let artistLabel: UILabel = {
        let label = UILabel()
        label.text = "Artist Name"
        label.font = .systemFont(ofSize: 13)
        label.textColor = .lightGray
        return label
    }()


    override init(frame: CGRect) {
        super.init(frame: frame)
        let stackView = VStack(arrangedSubviews: [imageView, titleLabel, artistLabel])
        sv(stackView)
        stackView.fillContainer()
        imageView.heightEqualsWidth()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError()
    }
}
