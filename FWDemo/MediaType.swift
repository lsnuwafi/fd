//
//  MediaJson.swift
//  FWDemo
//
//  Created by Shinan Liu on 6/25/21.
//

import Foundation

enum MediaType {
    case image
    case video
    case gif

    init?(value: String?) {

        guard let value = value else { return nil }

        switch value {
        case _ where value.contains("image/jpeg"):
            self = .image
        case _ where value.contains("image/png"):
            self = .image
        case _ where value.contains("video"):
            self = .video
        case _ where value.contains("image/gif"):
            self = .gif
        default:
            return nil
        }
    }
}
