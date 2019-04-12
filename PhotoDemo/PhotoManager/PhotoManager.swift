//
//  PhotoManager.swift
//  VonCamera
//
//  Created by Quan Li on 2019/4/11.
//  Copyright © 2019 liquan. All rights reserved.
//

import UIKit
import Photos

/*
 public enum PHAssetCollectionType : Int {
  case album       /// 自己创建的相册
 
  case smartAlbum  /// 经由系统相机得来的相册
 
  case moment      /// 自动生成的时间分组的相册
 }
 
 
 public enum PHAssetCollectionSubtype : Int {
 
 
 // PHAssetCollectionTypeAlbum regular subtypes
 case albumRegular             // 在iPhone中自己创建的相册
 
 case albumSyncedEvent         // 从iPhoto（就是现在的图片app）中导入图片到设备
 
 case albumSyncedFaces         // 从图片app中导入的人物照片
 
 case albumSyncedAlbum         // 从图片app导入的相册
 
 case albumImported            // 从其他的相机或者存储设备导入的相册
 
 
 // PHAssetCollectionTypeAlbum shared subtypes
 case albumMyPhotoStream    // 照片流，照片流和iCloud有关，如果在设置里关闭了iCloud开关，就获取不到了
 
 case albumCloudShared      // iCloud的共享相册，点击照片上的共享tab创建后就能拿到了，但是前提是你要在设置中打开iCloud的共享开关（打开后才能看见共享tab）
 
 
 // PHAssetCollectionTypeSmartAlbum subtypes
 case smartAlbumGeneric      //一般的照片
 
 case smartAlbumPanoramas    // 全景图、全景照片
 
 case smartAlbumVideos       // 视频
 
 case smartAlbumFavorites    // 标记为喜欢、收藏
 
 case smartAlbumTimelapses   // 延时拍摄、定时拍摄
 
 case smartAlbumAllHidden    // 隐藏的
 
 case smartAlbumRecentlyAdded  // 最近添加的、近期添加
 
 case smartAlbumBursts         // 连拍
 
 case smartAlbumSlomoVideos    // 慢动作视频
 
 case smartAlbumUserLibrary    // 相机胶卷
 
 @available(iOS 9.0, *)
 case smartAlbumSelfPortraits    // 使用前置摄像头拍摄的作品
 
 @available(iOS 9.0, *)
 case smartAlbumScreenshots      // 屏幕截图
 
 @available(iOS 10.2, *)
 case smartAlbumDepthEffect      // 使用深度摄像模式拍的照片
 
 @available(iOS 10.3, *)
 case smartAlbumLivePhotos       //Live Photo资源
 
 @available(iOS 11.0, *)
 case smartAlbumAnimated
 
 @available(iOS 11.0, *)
 case smartAlbumLongExposures
 
 // Used for fetching, if you don't care about the exact subtype
 case any
 }

 
 */


/// 首次权限获取成功，相册发生变化都会发送这个通知
let PhotosDidChange = NSNotification.Name.init("PhotosDidChange")

public class PhotoManager: NSObject {
    static let shared = PhotoManager()
    weak var authorizationDelegate:PhotoAuthorizationDelegate?
    
    /// 自己创建的相册
    var albumsFetchResult:PHFetchResult<PHAssetCollection>
    
    /// 经由系统相机得来的相册
    var smartAlbumFetchResult:PHFetchResult<PHAssetCollection>
    
    
    /// 自动生成的时间分组的相册
    var momentFetchResult:PHFetchResult<PHAssetCollection>
    
    
    public override init() {
        self.albumsFetchResult = PHAssetCollection.fetchAssetCollections(with: PHAssetCollectionType.album, subtype: PHAssetCollectionSubtype.any, options: nil)
        
        self.smartAlbumFetchResult = PHAssetCollection.fetchAssetCollections(with: PHAssetCollectionType.smartAlbum, subtype: PHAssetCollectionSubtype.any, options: nil)
        

        self.momentFetchResult = PHAssetCollection.fetchAssetCollections(with: PHAssetCollectionType.moment, subtype: PHAssetCollectionSubtype.any, options: nil)
        
        super.init()
        let _ = checkAuthorizationStatus()
        PHPhotoLibrary.shared().register(self)
    }
    
    deinit {
        PHPhotoLibrary.shared().unregisterChangeObserver(self)
    }
    
}
