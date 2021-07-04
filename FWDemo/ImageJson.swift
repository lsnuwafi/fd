//
//  ImageJson.swift
//  FWDemo
//
//  Created by Shinan Liu on 6/25/21.
//

import Foundation

struct ImageJson: Codable {
    let id: String
    let imageDescription: String?
    let datetime: Int
    let type: String
    let animated: Bool
    let width, height, size, views: Int
    let link: String
    let mp4, gifv, hls: String?

    enum CodingKeys: String, CodingKey {
        case id
        case imageDescription = "description"
        case datetime, type, animated, width, height, size, views, link
        case mp4, gifv, hls
    }

    var mediaType: MediaType? {
        return MediaType(value: type)
    }
}
