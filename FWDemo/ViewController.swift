//
//  ViewController.swift
//  FWDemo
//
//  Created by Shinan Liu on 6/25/21.
//

import UIKit
import RxSwift
import RxCocoa
import AVKit

class ViewController: UIViewController {

    weak var collectionView: UICollectionView!
    weak var searchTextField: UITextField!
    weak var searchButton: UIButton!
    private let viewModel: SearchViewModel = SearchViewModel()
    private let _disposeBag = DisposeBag()
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        initView()
        bindStatus()
        
    }
    
    func initView() {

        let cv = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
        cv.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(cv)
        
        let textField = UITextField()
        textField.translatesAutoresizingMaskIntoConstraints = false
        //textField.backgroundColor = .systemGray
        textField.layer.cornerRadius = 5
        textField.layer.borderWidth = 1
        textField.layer.borderColor = UIColor.gray.cgColor
        view.addSubview(textField)
        
        let button = UIButton()
        let buttonWidth = CGFloat(70)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("search", for: .normal)
        button.layer.cornerRadius = 5
        button.setTitleColor(.black, for: .normal)
        button.setTitleColor(.lightGray, for: .highlighted)
        button.contentHorizontalAlignment = .center
        button.backgroundColor = .systemBlue
        button.layer.borderWidth = 0.5
        button.layer.borderColor = UIColor.gray.cgColor
        button.addTarget(self, action: #selector(self.searchButtonTapped), for: .touchUpInside)
        view.addSubview(button)
    
        NSLayoutConstraint.activate([
            textField.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            textField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 5),
            textField.heightAnchor.constraint(equalToConstant: 30),
            textField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -(buttonWidth + 20)),
            
            button.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            button.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -5),
            button.heightAnchor.constraint(equalToConstant: 30),
            button.widthAnchor.constraint(equalToConstant: buttonWidth),
            
            cv.topAnchor.constraint(equalTo: textField.bottomAnchor, constant: 5),
            cv.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            cv.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            cv.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
        
        self.collectionView = cv
        self.searchTextField = textField
        self.searchButton = button
        
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.backgroundColor = .systemBackground
        collectionView.register(ImageCell.self, forCellWithReuseIdentifier: "imageCell")
        
    }
    
    func bindStatus() {
        viewModel.state.bind { (status) in
            DispatchQueue.main.async {
            //    self.backgroundView.isHidden = true
            //    self.refreshControl.endRefreshing()
                switch status {
                case .success:
                    self.collectionView.reloadData()
                case .loading:
                    break // todo loading
                case .error(error: _):
                    break
               //     self.backgroundView.isHidden = false
                    //removes itself if having an error to load
                }
            }
        }.disposed(by: _disposeBag)
    }
    
    @objc func searchButtonTapped() {
        guard let query = searchTextField.text else {
            return
        }
        if (query.isEmpty) {return}
        debugPrint(query)
        viewModel.fetchData(query)
    }
}

extension ViewController: UICollectionViewDelegate {
    
}

extension ViewController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.contents.count
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        debugPrint("index:", indexPath.row)

        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "imageCell", for: indexPath) as! ImageCell
        if (viewModel.contents.count == 0 || viewModel.contents.count < indexPath.row) {
            return cell
        }
        print(indexPath.row)
        cell.setup(content: viewModel.contents[indexPath.row])
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let cell = collectionView.cellForItem(at: indexPath) as! ImageCell
        let tap = UITapGestureRecognizer(target: self, action: #selector(dismissFullscreenImage))
        if cell.imageView.image == nil {
            debugPrint("this is video")
            let nview = UIView()
            let  playerLayer = AVPlayerLayer(player: cell.avplayer)
            nview.frame = UIScreen.main.bounds
            playerLayer.frame = UIScreen.main.bounds
            playerLayer.videoGravity = .resizeAspectFill
            nview.layer.addSublayer(playerLayer)
            nview.addGestureRecognizer(tap)
            view.addSubview(nview)
            playerLayer.player?.play()
            return
        }
        
        let newImageView = UIImageView(image: cell.imageView.image)
        newImageView.frame = UIScreen.main.bounds
        newImageView.backgroundColor = .black
        newImageView.contentMode = .scaleAspectFit
        newImageView.isUserInteractionEnabled = true
      
        newImageView.addGestureRecognizer(tap)
        view.addSubview(newImageView)
    }
    
    @objc func dismissFullscreenImage(_ sender: UITapGestureRecognizer) {
        sender.view?.removeFromSuperview()
    }
}

extension ViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 320, height: 366)
    }

}



   
