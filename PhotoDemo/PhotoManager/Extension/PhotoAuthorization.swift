//
//  PhotoAuthorization.swift
//  VonCamera
//
//  Created by Quan Li on 2019/4/11.
//  Copyright © 2019 liquan. All rights reserved.
//

import UIKit
import Photos

public enum PhotoAuthorizationStatus: Int, CustomStringConvertible {
    case photoNotDetermined = 0
    case photoNotAuthorized
    case photoAuthorized
    
    public var description: String {
        get {
            switch self {
            case .photoNotDetermined:
                return "Not Determined"
            case .photoNotAuthorized:
                return "Not Authorized"
            case .photoAuthorized:
                return "Authorized"
            }
        }
    }
}

public protocol PhotoAuthorizationDelegate:AnyObject{
    func requestPhotoAuthorizationResult(status:PhotoAuthorizationStatus)
}

public extension PhotoManager{
    func checkAuthorizationStatus() -> Bool {
        if authorizationStatus() == .photoAuthorized{
            return true
        }
        requestPhotoAuthorization()
        return false
    }
    
    
    func authorizationStatus() -> PhotoAuthorizationStatus{
        let status = PHPhotoLibrary.authorizationStatus()
        var photoStatus: PhotoAuthorizationStatus = .photoNotDetermined
        switch status {
        case .denied, .restricted:
            photoStatus = .photoNotAuthorized
            break
        case .authorized:
            photoStatus = .photoAuthorized
            break
        case .notDetermined:
            break
        @unknown default:
            print("unknown authorization type")
            break
        }
        return photoStatus
    }
    
    func requestPhotoAuthorization(){
        var photoStatus:PhotoAuthorizationStatus = .photoNotDetermined
        PHPhotoLibrary.requestAuthorization { (status) in
            switch status {
            case .denied, .restricted:
                photoStatus = .photoNotAuthorized
                break
            case .authorized:
                photoStatus = .photoAuthorized
                self.updateData()
                break
            case .notDetermined:
                break
            @unknown default:
                print("unknown authorization type")
                break
            }
            self.authorizationDelegate?.requestPhotoAuthorizationResult(status: photoStatus)
        }
    }
    
    func updateData()  {
        self.albumsFetchResult = PHAssetCollection.fetchAssetCollections(with: PHAssetCollectionType.album, subtype: PHAssetCollectionSubtype.any, options: nil)
        
        self.smartAlbumFetchResult = PHAssetCollection.fetchAssetCollections(with: PHAssetCollectionType.smartAlbum, subtype: PHAssetCollectionSubtype.any, options: nil)
        
        let option = PHFetchOptions.init()
        option.sortDescriptors = [NSSortDescriptor.init(key: "startDate", ascending: false)]
        self.momentFetchResult = PHAssetCollection.fetchAssetCollections(with: PHAssetCollectionType.moment, subtype: PHAssetCollectionSubtype.any, options: option)
        
        updateAlbumsFetchResult()
    }
}
