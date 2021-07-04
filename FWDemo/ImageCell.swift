//
//  ImageCell.swift
//  FWDemo
//
//  Created by Shinan Liu on 6/25/21.
//

import Foundation
import UIKit
import AVKit
import RxSwift
import RxCocoa

class ImageCell: UICollectionViewCell {
    weak var imageView: UIImageView!
    weak var viewsLabel: UILabel!
    weak var commentLabel: UILabel!
    weak var activityIndicator: UIActivityIndicatorView!
    var avplayer: AVPlayer?
    let playerController = AVPlayerViewController()
    let imageCache = ImageCache.sharedCache
    private var onLoadError: Error?
    private let _disposeBag = DisposeBag()
    private var _content: ContentJson?
    override init(frame: CGRect) {
        super.init(frame: frame)
        setUpImageView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setUpImageView() {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(imageView)
        NSLayoutConstraint.activate([
            imageView.topAnchor.constraint(equalTo: contentView.topAnchor),
            imageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            imageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            imageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor)
        ])
        self.imageView = imageView
    }
    
    func setup(content: ContentJson) {
        
        imageView.image = nil
        playerController.view.removeFromSuperview()
        switch content.mediaType {
            case .none:
                return
            case .some(let someType):
                switch someType {
                case .image, .gif:
                    setupImage(from: content)
                case .video:
                    setupVideo(from: content)
            }
        }
    }

    private func setupVideo(from content: ContentJson) {
        guard   let gif = content.images?.first?.mp4,
                let url = URL.init(string: gif) else { return }
        
        self.avplayer = AVPlayer(url: url)
        playerController.player = self.avplayer
        playerController.view.frame = self.contentView.frame
        playerController.player?.volume = 0
        playerController.entersFullScreenWhenPlaybackBegins = false
        playerController.player?.play()
        playerController.showsPlaybackControls = false
        playerController.videoGravity = .resizeAspectFill
        playerController.player?.addObserver(self, forKeyPath: "timeControlStatus", options: [.old, .new], context: nil)
        self.contentView.addSubview(playerController.view)
        
    }

    private func setupImage(from content: ContentJson) {
        let link = content.availableMediaLink

        guard let url = URL(string: link) else {
            print("There is no link to load")
            return
        }
      
        imageCache.getImage(for: url, onSuccess: { [weak self] (image, resolvedURL) in
                debugPrint("Content loaded", String(describing: content.type), " ",url)
            if url == resolvedURL {
                DispatchQueue.main.async {
                    self?.imageView.contentMode = .scaleToFill
                    self?.imageView.image = image
                }
            }
        }) { () in
            debugPrint("Content NOT loaded", String(describing: self._content?.type), " ",url)
            DispatchQueue.main.async {
                self.imageView.image = UIImage.init(named: "reload-1")
                self.imageView.contentMode = .center
                self.imageView.backgroundColor = UIColor.gray
            }
            
        }
    }

    override public func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if keyPath == "timeControlStatus", let change = change, let newValue = change[NSKeyValueChangeKey.newKey] as? Int, let oldValue = change[NSKeyValueChangeKey.oldKey] as? Int {
            if #available(iOS 10.0, *) {
                let oldStatus = AVPlayer.TimeControlStatus(rawValue: oldValue)
                let newStatus = AVPlayer.TimeControlStatus(rawValue: newValue)
                if newStatus != oldStatus {
                   DispatchQueue.main.async {[weak self] in
                       if newStatus == .playing || newStatus == .paused {
                 //       self!.activityIndicator.stopAnimating()
                       } else {
                //        self!.activityIndicator.startAnimating()
                       }
                   }
                }
            } else {
                // Fallback on earlier versions
             //   self.activityIndicator.stopAnimating()
            }
        }
    }
    


   
}
