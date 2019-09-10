//
//  ProgressSliderView.swift
//  Podcasts
//
//  Created by Nicholas Wong on 9/8/19.
//  Copyright © 2019 Nicholas Wong. All rights reserved.
//

import UIKit

class ProgressSliderView: UIView {

    let slider = UISlider()

    let elapsedTimeLabel: UILabel = {
        let label = UILabel()
        label.textColor = .lightGray
        label.font = .systemFont(ofSize: 14)
        label.textAlignment = .left
        label.text = "00:00"
        return label
    }()

    let totalTimeLabel: UILabel = {
        let label = UILabel()
        label.textColor = .lightGray
        label.font = .systemFont(ofSize: 14)
        label.textAlignment = .right
        label.text = "--:--"
        return label
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        let labelStackView = UIStackView(arrangedSubviews: [elapsedTimeLabel, totalTimeLabel])
        let sliderStackView = VStack(arrangedSubviews: [slider, labelStackView], spacing: 4)
        sv(sliderStackView)
        sliderStackView.fillContainer()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError()
    }
}
