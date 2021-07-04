//
//  GalleryJson.swift
//  FWDemo
//
//  Created by Shinan Liu on 6/25/21.
//

import Foundation

struct GalleryJson: Codable {
    let data: [ContentJson]
    let success: Bool
    let status: Int
}
