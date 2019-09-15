//
//  UserDefaults+Podcasts.swift
//  Podcasts
//
//  Created by Nicholas Wong on 9/14/19.
//  Copyright © 2019 Nicholas Wong. All rights reserved.
//

import Foundation

extension UserDefaults {

    static let savedPodcastsKey = "savedPodcastsKey"

    func savedPodcasts() -> [Podcast] {
        guard let savedPodcastsData = UserDefaults.standard.data(forKey: UserDefaults.savedPodcastsKey) else { return [] }
        do {
                let podcasts = try JSONDecoder().decode([Podcast].self, from: savedPodcastsData)
                return podcasts
        } catch let fetchError {
            print("Failed to fetch saved podcasts: Error: \(fetchError)")
            return []
        }
    }
}
