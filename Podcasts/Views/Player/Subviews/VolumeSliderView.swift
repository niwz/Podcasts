//
//  VolumeSliderView.swift
//  Podcasts
//
//  Created by Nicholas Wong on 9/8/19.
//  Copyright © 2019 Nicholas Wong. All rights reserved.
//

import UIKit

class VolumeSliderView: UIView {

    let noVolumeIcon: UIImageView = {
        let icon = UIImageView()
        icon.image = #imageLiteral(resourceName: "muted_volume")
        icon.size(40)
        return icon
    }()

    let slider: UISlider = {
        let slider = UISlider()
        slider.value = 1
        return slider
    }()

    let maxVolumeIcon: UIImageView = {
        let icon = UIImageView()
        icon.image = #imageLiteral(resourceName: "max_volume")
        icon.size(40)
        return icon
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        let stackView = UIStackView(arrangedSubviews: [noVolumeIcon, slider, maxVolumeIcon])
        sv(stackView)
        stackView.fillContainer()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError()
    }
}
