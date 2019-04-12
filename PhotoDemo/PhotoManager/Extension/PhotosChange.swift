//
//  PhotosChange.swift
//  VonCamera
//
//  Created by Quan Li on 2019/4/11.
//  Copyright © 2019 liquan. All rights reserved.
//

import UIKit
import Photos

extension PhotoManager:PHPhotoLibraryChangeObserver{
    public func photoLibraryDidChange(_ changeInstance: PHChange) {
        DispatchQueue.main.async {
            let changeToFetchResult:PHFetchResultChangeDetails? = changeInstance.changeDetails(for: self.albumsFetchResult)
            self.albumsFetchResult = changeToFetchResult?.fetchResultAfterChanges ?? self.albumsFetchResult
            guard let changeResult = changeToFetchResult else{
                return
            }
            if changeResult.hasIncrementalChanges{
                self.updateAlbumsFetchResult()
            }
        }
    }
    public func updateAlbumsFetchResult(){
        DispatchQueue.main.async {
            NotificationCenter.default.post(name: PhotosDidChange, object: nil)
        }
    }
}
