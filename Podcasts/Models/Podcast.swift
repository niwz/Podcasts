//
//   Podcast.swift
//  Podcasts
//
//  Created by Nicholas Wong on 9/6/19.
//  Copyright © 2019 Nicholas Wong. All rights reserved.
//

import Foundation

struct Podcast: Codable {
    var trackName: String?
    var artistName: String?
    var artworkUrl600: String?
    var trackCount: Int?
    var feedUrl: String?
}
