//
//  PlayerControlsView.swift
//  Podcasts
//
//  Created by Nicholas Wong on 9/8/19.
//  Copyright © 2019 Nicholas Wong. All rights reserved.
//

import UIKit

class PlayerControlsView: UIView {

    let rewindButton: UIButton = {
        let button = UIButton(type: .system)
        button.tintColor = .black
        button.setImage(#imageLiteral(resourceName: "rewind15"), for: .normal)
        return button
    }()

    let playButton: UIButton = {
        let button = UIButton(type: .system)
        button.tintColor = .black
        button.setImage(#imageLiteral(resourceName: "pause"), for: .normal)
        return button
    }()

    let forwardButton: UIButton = {
        let button = UIButton(type: .system)
        button.tintColor = .black
        button.setImage(#imageLiteral(resourceName: "fastforward15"), for: .normal)
        return button
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        let stackView = UIStackView(arrangedSubviews: [rewindButton, playButton, forwardButton])
        stackView.distribution = .fillEqually
        sv(stackView)
        stackView.fillContainer()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError()
    }
}
