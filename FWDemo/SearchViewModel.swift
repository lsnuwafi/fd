//
//  SerachViewModel.swift
//  FWDemo
//
//  Created by Shinan Liu on 6/26/21.
//

import Foundation
import RxSwift

class SearchViewModel {
    var contents: [ContentJson]  = []
    var state = BehaviorSubject<DataStatus>(value: .loading)
    init() {
        fetchData("cats")
    }
    
    func fetchData(_ query: String) {
        let url = URL(string: "https://api.imgur.com/3/gallery/search/?q=" + query)!
        var request = URLRequest(url: url)
        request.setValue("Client-ID b067d5cb828ec5a", forHTTPHeaderField: "Authorization")
        request.setValue("application/json", forHTTPHeaderField: "Accept")
        DefaultFWAPI.sharedAPI.fetchData(query, completionHandler: { galleryData in
            self.contents = galleryData.data
            self.state.onNext(.success)
        })

    }
}

enum DataStatus {
    case success
    case loading
    case error(error: Error)
}
