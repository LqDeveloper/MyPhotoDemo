//
//  AlbumManager.swift
//  VonCamera
//
//  Created by Quan Li on 2019/4/11.
//  Copyright © 2019 liquan. All rights reserved.
//

import UIKit
import Photos
extension PhotoManager{
    
    /// 创建相册
    ///
    /// - Parameter albumName: 相册的名字
    func createAlbum(albumName:String?) {
        guard let name = albumName else{
            return
        }
        PHPhotoLibrary.shared().performChanges({
            PHAssetCollectionChangeRequest.creationRequestForAssetCollection(withTitle: name)
        }) { (success, error) in
            if !success{
                print("创建相册失败 错误信息:\(error?.localizedDescription ?? "没有错误信息")")
            }
        }

    }
    
    /// 删除多个相册
    ///
    /// - Parameter albumsToBeDeleted: [PHAssetCollection]?
    func deleteAlbums(albumsToBeDeleted: [PHAssetCollection]?) {
        
        guard let albums = albumsToBeDeleted else {
            return
        }
        PHPhotoLibrary.shared().performChanges({
            PHAssetCollectionChangeRequest.deleteAssetCollections(albums as NSFastEnumeration)
        }) { (success, error) in
            if !success{
                print("删除多个相册失败 错误信息:\(error?.localizedDescription ?? "没有错误信息")")
            }
        }
    }

    
    /// 获取相册中的照片
    ///
    /// - Parameter album: PHAssetCollection
    /// - Returns: PHFetchResult<PHAsset>
    func getPhotosFromAlbum(album:PHAssetCollection?) -> PHFetchResult<PHAsset>? {
        guard let al = album else {
            return nil
        }
        return PHAsset.fetchAssets(in: al, options: nil)
    }
    
    
    /// 将图片加入相册
    ///
    /// - Parameters:
    ///   - image: UIImage
    ///   - toAlbum: PHAssetCollection
    func addImage(image:UIImage?,toAlbum:PHAssetCollection?){
        guard let img = image,let album = toAlbum  else {
            return
        }
        
        PHPhotoLibrary.shared().performChanges({
            let addImageRequest = PHAssetChangeRequest.creationRequestForAsset(from: img)
            let addedImagePlaceholder = addImageRequest.placeholderForCreatedAsset
            let addImageToAlbum = PHAssetCollectionChangeRequest.init(for: album)
            addImageToAlbum?.addAssets([addedImagePlaceholder] as NSFastEnumeration)
        }) { (success, error) in
            if !success{
                print("将图片加入相册失败 错误信息:\(error?.localizedDescription ?? "没有错误信息")")
            }
        }
    }
    
    
    /// 将照片从相册中删除
    ///
    /// - Parameter photoAssets: [PHAsset]
    func deleteImagesFromAlbum(photoAssets:[PHAsset]?){
        guard let photos = photoAssets else {
            return
        }
        PHPhotoLibrary.shared().performChanges({
            PHAssetChangeRequest.deleteAssets(photos as NSFastEnumeration)
        }) { (success, error) in
            if !success{
                print("将图片加入相册失败 错误信息:\(error?.localizedDescription ?? "没有错误信息")")
            }
        }
    }
    
    
    /// 将PHAsset 转成Image
    ///
    /// - Parameters:
    ///   - photoAsset: PHAsset
    ///   - imageSize:  图片尺寸
    ///   - contentMode: 拉伸模式
    ///   - resultHandler: 转换成功后的回调
    func changePHAssetToImage(photoAsset:PHAsset?,imageSize:CGSize = CGSize.init(width: 100, height: 100),contentMode:PHImageContentMode = PHImageContentMode.aspectFill,resultHandler: @escaping (UIImage?, [AnyHashable : Any]?) -> Void) {
        guard let photoA = photoAsset else {
            return
        }
        
        let imageManager =  PHImageManager.default()
        imageManager.requestImage(for: photoA, targetSize: imageSize, contentMode: contentMode, options: nil) { (image, imageInfo) in
            resultHandler(image,imageInfo)
        }
    }
}
