//
//  ViewController.swift
//  PhotoDemo
//
//  Created by Quan Li on 2019/4/12.
//  Copyright © 2019 williamoneilchina. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    lazy var tableView: UITableView = {[weak self]()->UITableView in
        let tableV = UITableView.init(frame: UIScreen.main.bounds)
        tableV.showsVerticalScrollIndicator = false
        tableV.delegate = self
        tableV.dataSource = self
        tableV.register(UITableViewCell.classForCoder(), forCellReuseIdentifier: "UITableViewCell")
        return tableV
        }()
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "相册"
        self.navigationController?.navigationBar.isHidden = false
        lq_configNavigationView()
        lq_addSubViews()
        lq_addNotification()
    }
    
    func lq_configNavigationView() {
        let btn = UIButton.init(type: .contactAdd)
        btn.addTarget(self, action: #selector(addAblum), for: .touchUpInside)
        self.navigationItem.rightBarButtonItem = UIBarButtonItem.init(customView: btn)
    }
    
    @objc func addAblum(){
        PhotoManager.shared.createAlbum(albumName: "这是新建的相册")
    }
    
    func lq_addSubViews() {
        view.addSubview(tableView)
    }
    
    func lq_addNotification() {
        NotificationCenter.default.addObserver(self, selector: #selector(updateAlbum), name: PhotosDidChange, object: nil)
    }
    
    func lq_removeNotification() {
        NotificationCenter.default.removeObserver(self)
    }
    
    @objc func updateAlbum(){
        self.tableView.reloadData()
    }
    
    deinit {
        lq_removeNotification()
    }
    
}


extension ViewController:UITableViewDelegate,UITableViewDataSource{
    func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
        return UITableViewCell.EditingStyle.delete
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete{
            let album = PhotoManager.shared.albumsFetchResult[indexPath.row]
            PhotoManager.shared.deleteAlbums(albumsToBeDeleted: [album])
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return PhotoManager.shared.albumsFetchResult.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "UITableViewCell", for: indexPath)
        let album = PhotoManager.shared.albumsFetchResult[indexPath.row]
        cell.textLabel?.text = album.localizedTitle
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let album = PhotoManager.shared.albumsFetchResult[indexPath.row]
        let photosVC = PhotosViewController.init()
        photosVC.ablum = album
        self.navigationController?.pushViewController(photosVC, animated: true)
    }
}
