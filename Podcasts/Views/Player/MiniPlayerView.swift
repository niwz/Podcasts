//
//  MiniPlayerView.swift
//  Podcasts
//
//  Created by Nicholas Wong on 9/9/19.
//  Copyright © 2019 Nicholas Wong. All rights reserved.
//

import UIKit
import Stevia

class MiniPlayerView: UIView {

    let episodeImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.size(64)
        imageView.image = #imageLiteral(resourceName: "appicon")
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.heightEqualsWidth()
        return imageView
    }()

    let titleLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 17, weight: .semibold)
        label.width(180)
        return label
    }()

    let playButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(#imageLiteral(resourceName: "pause"), for: .normal)
        button.tintColor = .black
        button.size(40)
        return button
    }()

    let forwardButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(#imageLiteral(resourceName: "fastforward15"), for: .normal)
        button.tintColor = .black
        button.size(40)
        return button
    }()

    let separatorView: UIView = {
        let view = UIView()
        view.height(0.5)
        view.backgroundColor = UIColor(white: 0.5, alpha: 0.3)
        return view
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        let stackView = UIStackView(arrangedSubviews: [episodeImageView, titleLabel, playButton, forwardButton])
        stackView.spacing = 16
        stackView.alignment = .center
        stackView.distribution = .equalCentering
        sv(separatorView, stackView)
        separatorView.top(0).fillHorizontally()
        stackView.fillContainer(16)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError()
    }
}
