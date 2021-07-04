//
//  ImageCache.swift
//  FWDemo
//
//  Created by Shinan Liu on 6/26/21.
//

import Foundation
import UIKit

protocol ImageCacheProtocal {
    func getImage(for: URL, onSuccess: @escaping (_ image: UIImage, _ url: URL) -> Void, onError: @escaping  ()->Void)
    func cleanCache()
}


class ImageCache: ImageCacheProtocal {
    static var sharedCache: ImageCache = ImageCache()
    private var _cache = [URL: UIImage]() //the most simplest cache ever

    func getImage(for imageURL: URL, onSuccess: @escaping  (_ image: UIImage, _ imageURL: URL) -> Void, onError: @escaping ()->Void) {
        if let cachedImage =  _cache[imageURL] {
            onSuccess(cachedImage, imageURL)
            return
        }
        DispatchQueue.global().async {
            let data = try? Data(contentsOf: imageURL)
            if data == nil {
                
                debugPrint("no data on", imageURL.absoluteString)
                onError()
                return
            }
            guard let image = UIImage(data: data!) else {
                debugPrint("can not parse data on", imageURL.absoluteString)
                onError()
                return
            }
            self._cache[imageURL] = image
            onSuccess(image, imageURL)
        }
        
    }

    func cleanCache() {
        _cache = [URL: UIImage]()
    }

}

