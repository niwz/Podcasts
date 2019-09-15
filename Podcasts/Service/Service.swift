//
//  Service.swift
//  Podcasts
//
//  Created by Nicholas Wong on 9/7/19.
//  Copyright © 2019 Nicholas Wong. All rights reserved.
//

import Foundation
import Alamofire
import FeedKit

extension NSNotification {
    static let downloadProgress = NSNotification.Name("downloadProgress")
    static let downloadComplete = NSNotification.Name("downloadComplete")
}

class Service {

    static let shared = Service()

    func fetchPodcasts(_ searchText: String, _ completion: @escaping ([Podcast]) -> ()) {
        let url = "https://itunes.apple.com/search"
        let parameters = ["term": searchText, "media": "podcast"]
        Alamofire.request(url, method: .get, parameters: parameters, encoding: URLEncoding.default, headers: nil).responseData { (dataResponse) in
            if let err = dataResponse.error {
                print("Failed to search for podcast: ", err)
            }
            guard let data = dataResponse.data else { return }
            do {
                let searchResult = try JSONDecoder().decode(SearchResult.self, from: data)
                completion(searchResult.results)
            } catch let decodeErr {
                print("Failed to decode: ", decodeErr)
            }
        }
    }

    func fetchEpisodes(_ feedUrl: String, _ completion: @escaping ([Episode]) -> ()) {
        guard let url = URL(string: feedUrl) else { return }
        DispatchQueue.global(qos: .background).async {
            let parser = FeedParser(URL: url)
            parser.parseAsync(result: { (result) in
                print("Successfully parsed feed:", result.isSuccess)
                if let err = result.error {
                    print("Failed to parse XML feed: ", err)
                }
                guard let feed = result.rssFeed else { return }
                let episodes = feed.toEpisodes()
                completion(episodes)
            })
        }
    }


    typealias EpisodeDownloadCompleteTuple = (fileUrl: String, episodeTitle: String)

    func downloadEpisode(episode: Episode) {
        
        let downloadRequest = DownloadRequest.suggestedDownloadDestination()

        Alamofire.download(episode.streamUrl, to: downloadRequest).downloadProgress { (progress) in
            NotificationCenter.default.post(name: NSNotification.downloadProgress, object: nil, userInfo: ["title": episode.title, "progress": progress.fractionCompleted])
            }.response { (response) in
                let episodeDownloadComplete = EpisodeDownloadCompleteTuple(response.destinationURL?.absoluteString ?? "", episode.title)
                NotificationCenter.default.post(name: NSNotification.downloadComplete, object: episodeDownloadComplete)
                var downloadedEpisodes = UserDefaults.standard.downloadedEpisodes()
                guard let episodeIndex = downloadedEpisodes.firstIndex(where: { $0.title == episode.title && $0.author == episode.author }) else { return }
                downloadedEpisodes[episodeIndex].fileUrl = response.destinationURL?.absoluteString ?? ""
                do {
                    let updatedEpisodesData = try JSONEncoder().encode(downloadedEpisodes)
                    UserDefaults.standard.set(updatedEpisodesData, forKey: UserDefaults.downloadedEpisodesKey)
                } catch let err {
                    print("Failed to encode downloaded episode: ", err)
                }
        }
    }
}
