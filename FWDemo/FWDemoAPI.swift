//
//  File.swift
//  FWDemo
//
//  Created by Shinan Liu on 6/25/21.
//

import Foundation
import RxSwift
import RxCocoa

protocol FWDemoAPI {
    func fetchData(_ query: String, completionHandler:@escaping (_ jsonData: GalleryJson)->Void)
}

class DefaultFWAPI: FWDemoAPI {
    
    let urlSession = URLSession.shared
    static var sharedAPI: DefaultFWAPI = DefaultFWAPI()

    func fetchData(_ query: String, completionHandler:@escaping (_ jsonData: GalleryJson)->Void) {
        let url = URL(string: "https://api.imgur.com/3/gallery/search/?q=" + query)!
        var request = URLRequest(url: url)
        request.setValue("Client-ID b067d5cb828ec5a", forHTTPHeaderField: "Authorization")
        request.setValue("application/json", forHTTPHeaderField: "Accept")
    
        let task = URLSession.shared.dataTask(with: request) {(data, response, error) in
            if let jsonData = data {
                let galleryData = try! JSONDecoder().decode(GalleryJson.self, from: jsonData)
                completionHandler(galleryData)
            }
        }
        task.resume()
    }
    
    
}
