//
//  PlayerDetailView+Gestures.swift
//  Podcasts
//
//  Created by Nicholas Wong on 9/10/19.
//  Copyright © 2019 Nicholas Wong. All rights reserved.
//

import UIKit

extension PlayerDetailView {
    @objc func handleTapMaximize() {
        guard let mainTabController = UIApplication.shared.keyWindow?.rootViewController as? MainTabBarController else { return }
        mainTabController.maximizePlayer()
    }

    private func handlePanEnded(_ gesture: UIPanGestureRecognizer) {
        let translation = gesture.translation(in: self.superview)
        let velocity = gesture.velocity(in: self.superview)
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.7, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
            self.transform = .identity
            let mainTabBarController = UIApplication.mainTabBarController()
            if translation.y < -200 || velocity.y < -500 {
                mainTabBarController?.maximizePlayer()
            } else {
                self.miniPlayerView.alpha = 1
                self.maximizedStackView.alpha = 0
            }
        })
    }

    private func handlePanChanged(_ gesture: UIPanGestureRecognizer, dismissal: Bool = false) {
        let translation = gesture.translation(in: self.superview)
        self.transform = CGAffineTransform(translationX: 0, y: translation.y)
        if dismissal {
            maximizedStackView.alpha = 1 + translation.y / 200
            miniPlayerView.alpha = -translation.y / 200
        } else {
            miniPlayerView.alpha = 1 + translation.y / 200
            maximizedStackView.alpha = -translation.y / 200
        }
    }

    @objc func handlePan(gesture: UIPanGestureRecognizer) {
        if gesture.state == .changed {
            handlePanChanged(gesture)
        } else if gesture.state == .ended {
            handlePanEnded(gesture)
        }
    }

    @objc func handleDismissalPan(gesture: UIPanGestureRecognizer) {
        if gesture.state == .changed {
            handlePanChanged(gesture, dismissal: true)
        } else if gesture.state == .ended {
            let translation = gesture.translation(in: self.superview)
            UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.7, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
                self.transform = .identity
                let mainTabBarController = UIApplication.mainTabBarController()
                if translation.y > 50 {
                    mainTabBarController?.minimizePlayer()
                } else {
                    self.miniPlayerView.alpha = 0
                    self.maximizedStackView.alpha = 1
                }
            })
        }
    }
}
