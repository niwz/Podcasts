//
//  UIApplication+Podcasts.swift
//  Podcasts
//
//  Created by Nicholas Wong on 9/10/19.
//  Copyright © 2019 Nicholas Wong. All rights reserved.
//

import UIKit

extension UIApplication {
    static func mainTabBarController() -> MainTabBarController? {
        return shared.keyWindow?.rootViewController as? MainTabBarController
    }
}
