//
//  HomeController.swift
//  ClickAndShare
//
//  Created by Madhusudhan B.R on 7/18/17.
//  Copyright © 2017 Madhusudhan. All rights reserved.
//

import UIKit
import Firebase

class HomeController: UICollectionViewController, UICollectionViewDelegateFlowLayout{
    
    let cellID = "cell"
    var Posts = [Post]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView?.backgroundColor = UIColor.white
        collectionView?.register(HomeFeedCell.self, forCellWithReuseIdentifier: cellID)
        fetchPosts()
    }
    
    func fetchPosts() {
        
        guard let currentuserID = Auth.auth().currentUser?.uid else {
            return }
        
        let postsRef = Database.database().reference().child("posts").child(currentuserID)
            postsRef.queryOrdered(byChild: "creationDate").observeSingleEvent(of: .value, with: { (snapshot) in
            guard let Dict = snapshot.value as? [String: Any] else { return }
                
                for eachDict in Dict{
                    guard let subDict = eachDict.value as? [String: Any] else { return }
                    guard let caption = subDict["caption"] as? String else {
                        return
                    }
                    guard let creationDate = subDict["creationDate"] as? NSNumber else {
                        return
                    }
                    guard let imageHeight = subDict["imageHeight"] as? CGFloat else {
                        return
                    }
                    guard let imageWidth = subDict["imageWidth"] as? CGFloat else {
                        return
                    }
                    guard let imageUrl = subDict["imageUrl"] as? String else {
                        return
                    }
                    
                    let post = Post(caption: caption, imageHeight: imageHeight , imageWidth: imageWidth, imageUrl: imageUrl, creationDate: creationDate)
                    print(post)
                    self.Posts.append(post)

                }
                
                
                DispatchQueue.main.async {
                self.collectionView?.reloadData()
            }
            

        }) { (error) in
            print(error.localizedDescription)
        }
        
        
      
    }
    
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return Posts.count
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        var height:CGFloat = 56.0+50.0
        height += view.frame.width
        return CGSize(width: view.frame.width, height: height)
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellID, for: indexPath) as! HomeFeedCell
        let post = Posts[indexPath.row]
        cell.post = post
        return cell 
    }
}
