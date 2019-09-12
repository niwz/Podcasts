//
//  EpisodeCell.swift
//  Podcasts
//
//  Created by Nicholas Wong on 9/7/19.
//  Copyright © 2019 Nicholas Wong. All rights reserved.
//

import UIKit
import Stevia

class EpisodeCell: UITableViewCell {

    var episode: Episode! {
        didSet {
            titleLabel.text = episode.title
            let description = episode.description.replacingOccurrences(of: "<[^>]+>", with: "", options: .regularExpression, range: nil)
            descriptionLabel.text = description
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "MMM dd, yyyy"
            pubDateLabel.text = dateFormatter.string(from: episode.pubDate)
            let episodeImageUrl = URL(string: episode.imageUrl ?? "")
            episodeImageView.sd_setImage(with: episodeImageUrl)
        }
    }

    let episodeImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        return imageView
    }()

    let titleLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 2
        label.font = .boldSystemFont(ofSize: 17)
        return label
    }()

    let descriptionLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 14)
        label.numberOfLines = 2
        label.textColor = .lightGray
        return label
    }()

    let pubDateLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 15)
        label.textColor = .purple
        return label
    }()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        let stackView = VStack(arrangedSubviews: [pubDateLabel, titleLabel, descriptionLabel], spacing: 5)
        sv(episodeImageView, stackView)
        layout([16,
                |-16-episodeImageView.size(100)-12-stackView-|,
                16])
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError()
    }
}
