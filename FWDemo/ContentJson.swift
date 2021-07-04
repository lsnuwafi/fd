//
//  ContentJson.swift
//  FWDemo
//
//  Created by Shinan Liu on 6/25/21.
//

import Foundation
struct ContentJson: Codable {
    
    let id, title: String
    let ups, downs, commentCount, views: Int
    let link: String
    let type: String?
    let images: [ImageJson]?

    enum CodingKeys: String, CodingKey {
        case id, title, ups, downs, type
        case commentCount = "comment_count"
        case views, link, images
    }

    var availableMediaLink: String {
        return images?.first?.link ?? link
    }

    var mediaType: MediaType? {
        return MediaType(value: images?.first?.type ?? type)
    }

    var availableMediaIsImage: Bool {
        let mediaType = (images?.first?.type ?? type) ?? ""
        return mediaType.contains("image/jpeg") || mediaType.contains("image/png")
    }

}
