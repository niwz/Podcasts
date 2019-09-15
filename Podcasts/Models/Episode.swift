//
//  Episode.swift
//  Podcasts
//
//  Created by Nicholas Wong on 9/7/19.
//  Copyright © 2019 Nicholas Wong. All rights reserved.
//

import Foundation
import FeedKit

struct Episode: Codable {
    let title: String
    let author: String
    let description: String
    let pubDate: Date
    var imageUrl: String?
    var streamUrl: String
    var fileUrl: String?

    init(feedItem: RSSFeedItem) {
        self.title = feedItem.title ?? ""
        self.author = feedItem.iTunes?.iTunesAuthor ?? ""
        self.description = feedItem.description ?? ""
        self.pubDate = feedItem.pubDate ?? Date()
        self.imageUrl = feedItem.iTunes?.iTunesImage?.attributes?.href
        self.streamUrl = feedItem.enclosure?.attributes?.url ?? ""
    }
}
