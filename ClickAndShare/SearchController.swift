//
//  SearchController.swift
//  ClickAndShare
//
//  Created by Madhusudhan B.R on 7/19/17.
//  Copyright © 2017 Madhusudhan. All rights reserved.
//

import UIKit



class SearchController : UICollectionViewController,UICollectionViewDelegateFlowLayout {
    
    let cellId = "cell"
    let searchBar: UISearchBar = {
        let sb = UISearchBar()
        sb.placeholder = "Enter search text"
        UITextField.appearance(whenContainedInInstancesOf:[UISearchBar.self]).backgroundColor = UIColor.rgb(red: 230, green: 230, blue: 230)
        return sb
    }()
    
    override func viewDidLoad() {
         super.viewDidLoad()
        
        collectionView?.register(SearchCell.self, forCellWithReuseIdentifier: cellId)
         collectionView?.backgroundColor = UIColor.white
        collectionView?.alwaysBounceVertical = true 
        navigationController?.navigationBar.addSubview(searchBar)
        let navBar = navigationController?.navigationBar
        searchBar.anchor(top: navBar?.topAnchor, left: navBar?.leftAnchor, bottom: navBar?.bottomAnchor, right: navBar?.rightAnchor, paddingTop: 0, paddingLeft: 8, paddingBottom: 0, paddingRight: 8, width: 0, height: 0)
    }
    
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 5
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! SearchCell
        
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: view.frame.width, height: 60)
    }
}
