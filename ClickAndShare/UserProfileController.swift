//
//  UserProfileController.swift
//  ClickAndShare
//
//  Created by Madhusudhan B.R on 7/10/17.
//  Copyright © 2017 Madhusudhan. All rights reserved.
//

import UIKit
import Firebase

class UserProfileController: UICollectionViewController, UICollectionViewDelegateFlowLayout,UserProfileDelegate {
    
    var user: User?
    var userId: String?
    var currentUserID: String?
    var currentUserPosts = [Post]()
    var isGrid = true
    var isPagingDone = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView?.backgroundColor = .white
        fetchUser()
        collectionView?.register(UserProfileHeader.self, forSupplementaryViewOfKind: UICollectionElementKindSectionHeader, withReuseIdentifier: "header")
        collectionView?.register(UserProfileCell.self, forCellWithReuseIdentifier: "cell")
        collectionView?.register(HomeFeedCell.self, forCellWithReuseIdentifier: "homecell")
        setupLogoutController()
        
        
    }
    
    fileprivate func observePostsWithPaging(){
        let postsRef = Database.database().reference().child("posts").child(currentUserID!)
        var query = postsRef.queryOrdered(byChild: "creationDate")
        
        if currentUserPosts.count > 0 {
            let value = currentUserPosts.last?.creationDate
            query = query.queryEnding(atValue: value)
        }
        
        query.queryLimited(toLast: 4).observeSingleEvent(of: .value, with: { (snapshot) in
            guard  var allObjects = snapshot.children.allObjects as? [DataSnapshot] else { return }
            allObjects.reverse()
            if allObjects.count < 4 {
                self.isPagingDone = true
            }
            if self.currentUserPosts.count > 0 {
                allObjects.removeFirst()
            }
            for object in allObjects {
                guard let eachDict = object.value as? [String: Any] else { return }
                guard let caption = eachDict["caption"] as? String else {
                    return
                }
                guard let creationDate = eachDict["creationDate"] as? NSNumber else {
                    return
                }
                guard let imageHeight = eachDict["imageHeight"] as? CGFloat else {
                    return
                }
                guard let imageWidth = eachDict["imageWidth"] as? CGFloat else {
                    return
                }
                guard let imageUrl = eachDict["imageUrl"] as? String else {
                    return
                }
                guard let key = object.key as? String else { return }
                
                let post = Post(user: self.user!,caption: caption, imageHeight: imageHeight , imageWidth: imageWidth, imageUrl: imageUrl, creationDate: creationDate, postId: key)
                print(post)
                
//                self.currentUserPosts.insert(post, at: 0)
                self.currentUserPosts.append(post)
                self.collectionView?.reloadData()

            }
           
        }) { (error) in
            print(error.localizedDescription)
        }
    }
    
    fileprivate func observeMyPosts(){
        
        let postsRef = Database.database().reference().child("posts").child(currentUserID!)
        
        postsRef.queryOrdered(byChild: "creationDate").observe(.childAdded, with: { (snapshot) in
            guard let eachDict = snapshot.value as? [String: Any] else { return }
            guard let caption = eachDict["caption"] as? String else {
                return
            }
            guard let creationDate = eachDict["creationDate"] as? NSNumber else {
                return
            }
            guard let imageHeight = eachDict["imageHeight"] as? CGFloat else {
                return
            }
            guard let imageWidth = eachDict["imageWidth"] as? CGFloat else {
                return
            }
            guard let imageUrl = eachDict["imageUrl"] as? String else {
                return
            }
            guard let key = snapshot.key as? String else { return }
            
            let post = Post(user: self.user!,caption: caption, imageHeight: imageHeight , imageWidth: imageWidth, imageUrl: imageUrl, creationDate: creationDate, postId: key)
            print(post)
            self.currentUserPosts.insert(post, at: 0)
            // self.currentUserPosts.append(post)
            self.collectionView?.reloadData()
        }) { (error) in
            print(error)
        }
    }
    
    fileprivate func setupLogoutController() {
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: #imageLiteral(resourceName: "gear").withRenderingMode(.alwaysOriginal),  style: .plain, target: self, action: #selector(handleLogout))
    }
    
    func handleLogout(){
        let alertController = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        
        alertController.addAction(UIAlertAction(title: "Log Out", style: .destructive, handler: { (_) in
            do {
                try Auth.auth().signOut()
                let loginController = LoginController()
                let navController = UINavigationController(rootViewController: loginController)
                self.present(navController, animated: true, completion: nil)
            }catch let error {
                print(error)
            }
            
            
            
        }))
        alertController.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        
        present(alertController, animated: true, completion: nil)
    }
    
    override func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "header", for: indexPath) as! UserProfileHeader
        header.user = self.user
        header.delegate = self
        return header
    }
    
    func didTapList() {
        isGrid = false
        collectionView?.reloadData()
    }
    
    func didTapGrid() {
        isGrid = true
        collectionView?.reloadData()
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize(width: view.frame.width, height: 200)
    }
    
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return currentUserPosts.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if indexPath.item == self.currentUserPosts.count-1 && !isPagingDone {
            self.observePostsWithPaging()
        }
        
        if isGrid {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! UserProfileCell
            let post = self.currentUserPosts[indexPath.item]
            cell.imageView.loadImage(urlString: post.imageUrl ?? "")
            return cell
        }else {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "homecell", for: indexPath) as! HomeFeedCell
            let post = currentUserPosts[indexPath.row]
            cell.post = post
            return cell
        }
        
    
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if isGrid  {
            let width = (view.frame.width - 2) / 3
            return CGSize(width: width, height: width)
        }
        else{
            var height:CGFloat = 56.0+50.0 + 50.0
            height += view.frame.width
            return CGSize(width: view.frame.width, height: height)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 1
    }
    
    fileprivate func fetchUser(){

        
        let UID = self.userId ?? Auth.auth().currentUser?.uid ?? ""
        self.currentUserID = UID
        
        Database.fetchuserWithUid(uid: UID) { (user) in
            
            
            self.user = user
            self.navigationItem.title = user.username
            self.collectionView?.reloadData()
            self.observePostsWithPaging()

        }
        
        
        
    }
    
}
