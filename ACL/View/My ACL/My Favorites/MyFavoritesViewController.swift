//
//  MyFavoritesViewController.swift
//  ACL
//
//  Created by Gagandeep on 13/07/20.
//  Copyright © 2020 RGND. All rights reserved.
//

import UIKit

class MyFavoritesViewController: BaseViewController {
    @IBOutlet weak var collectionView: UICollectionView!
    
    var viewmodel = MyFavoritesViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func backAction(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.backGroundImageView.alpha = 1
    }
    override func viewWillDisappear(_ animated: Bool) {
        self.backGroundImageView.alpha = 0.7
    }

}

extension MyFavoritesViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewmodel.favoriteList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MyFavoritesCollectionCell", for: indexPath) as? MyFavoritesCollectionCell else {
            return MyFavoritesCollectionCell()
        }
        
        let item = viewmodel.favoriteList[indexPath.row]
        
        cell.titleImage.image = UIImage(named: item.imageName ?? "")
        cell.titleLabel.text = item.title
    
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        return CGSize(width: UIScreen.main.bounds.width/2 - 10, height: 105)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let item = viewmodel.favoriteList[indexPath.row]
        pushToContentViewController(title: item.title ?? "")
    }
    
    //MARK: push to content view controller
    func pushToContentViewController(title: String){
        let vc = storyboard?.instantiateViewController(withIdentifier: "MyFavoritesContentViewController") as? MyFavoritesContentViewController
        vc?.subTitle = title
        navigationController?.pushViewController(vc!, animated: true)
    }
    
    
}

class MyFavorite {
    
    var id: String?
    var title: String?
    var imageName: String?
    
    init(_ data: [String: Any]) {
        self.id = data["id"] as? String
        self.title = data["title"] as? String
        self.imageName = data["image"] as? String
    }
}

class MyFavoritesViewModel {
    
    init() {
        loadList()
    }
    
    var favoriteList: [MyFavorite] = [MyFavorite]()
    
    func loadList() {
        if let file = Bundle.main.path(forResource: "MyFavorites", ofType: "plist") {
            // refresh list
            favoriteList.removeAll()
            // get items
            if let fileArray = NSArray(contentsOfFile: file) as? [[String: Any]] {
                for data in fileArray {
                    favoriteList.append(MyFavorite(data))
                }
            }
        }
    }
}
