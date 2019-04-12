//
//  PhotosViewController.swift
//  VonCamera
//
//  Created by Quan Li on 2019/4/12.
//  Copyright © 2019 liquan. All rights reserved.
//

import UIKit
import Photos
class PhotosViewController: UIViewController {
    var ablum:PHAssetCollection?{
        willSet{
            if let ab = newValue {
                photos = PhotoManager.shared.getPhotosFromAlbum(album: ab)
            }
        }
    }
    
    var photos:PHFetchResult<PHAsset>?
    
    lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout.init()
        layout.minimumLineSpacing = 10
        layout.minimumInteritemSpacing = 10
        layout.itemSize = CGSize.init(width: ((UIScreen.main.bounds.size.width - 20)/3), height: (UIScreen.main.bounds.size.width - 20)/3)
        let collection  = UICollectionView.init(frame: UIScreen.main.bounds, collectionViewLayout: layout)
        collection.delegate = self
        collection.dataSource = self
        collection.backgroundColor = UIColor.white
        collection.showsVerticalScrollIndicator = false
        collection.register(UICollectionViewCell.classForCoder(), forCellWithReuseIdentifier: "UICollectionViewCell")
        return collection
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        lq_configNavigationView()
        lq_addSubViews()
        lq_addNotification()
    }
    
    func lq_addSubViews() {
        view.addSubview(collectionView)
    }
    
    func lq_configNavigationView() {
        let btn = UIButton.init(type: .contactAdd)
        btn.addTarget(self, action: #selector(addAblum), for: .touchUpInside)
        self.navigationItem.rightBarButtonItem = UIBarButtonItem.init(customView: btn)
    }
    
    @objc func addAblum(){
        PhotoManager.shared.addImage(image: UIImage.init(named: "image.jpg"), toAlbum: self.ablum)
    }
    
    func lq_addNotification() {
        NotificationCenter.default.addObserver(self, selector: #selector(updateAlbum), name: PhotosDidChange, object: nil)
    }
    
    func lq_removeNotification() {
        NotificationCenter.default.removeObserver(self)
    }
    
    @objc func updateAlbum(){
        self.photos = PhotoManager.shared.getPhotosFromAlbum(album: self.ablum)
        self.collectionView.reloadData()
    }

}


extension PhotosViewController:UICollectionViewDelegate,UICollectionViewDataSource{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return photos?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "UICollectionViewCell", for: indexPath)
        
        for view in cell.contentView.subviews {
            view.removeFromSuperview()
        }
        
        let imageView = UIImageView.init(frame: cell.contentView.frame)
        cell.addSubview(imageView)
        
        PhotoManager.shared.changePHAssetToImage(photoAsset: photos?[indexPath.row]) { (image, info) in
            imageView.image = image
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let photo = photos?[indexPath.row]
        guard let p = photo else{
            return
        }
        PhotoManager.shared.deleteImagesFromAlbum(photoAssets: [p])
    }
}
