//
//  SearchResult.swift
//  Podcasts
//
//  Created by Nicholas Wong on 9/7/19.
//  Copyright © 2019 Nicholas Wong. All rights reserved.
//

import Foundation

struct SearchResult: Decodable {
    let resultCount: Int
    let results: [Podcast]
}
