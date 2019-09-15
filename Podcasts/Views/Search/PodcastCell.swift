//
//  PodcastCell.swift
//  Podcasts
//
//  Created by Nicholas Wong on 9/7/19.
//  Copyright © 2019 Nicholas Wong. All rights reserved.
//

import UIKit
import Stevia
import SDWebImage

class PodcastCell: UITableViewCell {

    let trackNameLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 2
        label.font = .boldSystemFont(ofSize: 17)
        return label
    }()
    let artistNameLabel = UILabel()
    let episodeCountLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 14)
        label.textColor = .lightGray
        return label
    }()
    let podcastImageView = UIImageView()

    var podcast: Podcast! {
        didSet {
            trackNameLabel.text = podcast.trackName
            artistNameLabel.text = podcast.artistName
            episodeCountLabel.text = "\(podcast.trackCount ?? 0) episodes"
            guard let podcastImageUrl = URL(string: podcast.artworkUrl600 ?? "") else { return }
            podcastImageView.sd_setImage(with: podcastImageUrl)
        }
    }

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        let stackView = VStack(arrangedSubviews: [trackNameLabel, artistNameLabel, episodeCountLabel], spacing: 8)
        sv(podcastImageView, stackView)
        layout([16,
            |-16-podcastImageView.size(100)-12-stackView-|,
            16])
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError()
    }
}
