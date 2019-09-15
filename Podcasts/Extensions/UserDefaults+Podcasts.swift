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
    static let downloadedEpisodesKey = "downloadedEpisodesKey"

    func savedPodcasts() -> [Podcast] {
        guard let savedPodcastsData = UserDefaults.standard.data(forKey: UserDefaults.savedPodcastsKey) else { return [] }
        do {
                let podcasts = try JSONDecoder().decode([Podcast].self, from: savedPodcastsData)
                return podcasts
        } catch let fetchError {
            print("Failed to fetch saved podcasts: Error: \(fetchError)")
        }
        return []
    }

    func downloadEpisode(_ episode: Episode) {
        do {
            var downloadedEpisodes = UserDefaults.standard.downloadedEpisodes()
            downloadedEpisodes.append(episode)
            let episodesData = try JSONEncoder().encode(downloadedEpisodes)
            UserDefaults.standard.set(episodesData, forKey: UserDefaults.downloadedEpisodesKey)
        } catch let downloadError {
            print("Unable to download episode: ", downloadError)
        }
    }

    func downloadedEpisodes() -> [Episode] {
        guard let downloadedEpisodesData = UserDefaults.standard.data(forKey: UserDefaults.downloadedEpisodesKey) else { return [] }
        do {
            let episodes = try JSONDecoder().decode([Episode].self, from: downloadedEpisodesData)
            return episodes
        } catch let fetchError {
            print("Failed to fetch downloaded episodes: Error: \(fetchError)")
        }
        return []
    }
}
