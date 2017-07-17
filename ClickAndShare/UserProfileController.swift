//
//  UserProfileController.swift
//  ClickAndShare
//
//  Created by Madhusudhan B.R on 7/10/17.
//  Copyright © 2017 Madhusudhan. All rights reserved.
//

import UIKit
import Firebase

class UserProfileController: UICollectionViewController, UICollectionViewDelegateFlowLayout {
    
    var user: User?
    var currentUserID: String?
    var currentUserPosts = [Post]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView?.backgroundColor = .white
        fetchUser()
        collectionView?.register(UserProfileHeader.self, forSupplementaryViewOfKind: UICollectionElementKindSectionHeader, withReuseIdentifier: "header")
        collectionView?.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "cell")
        
        setupLogoutController()
        
        observeMyPosts()
    }
    
    fileprivate func observeMyPosts(){
        
        let postsRef = Database.database().reference().child("posts").child(currentUserID!)
        postsRef.observe(.childAdded, with: { (snapshot) in
            guard let dict = snapshot.value as? [String: Any] else { return }
            
            guard let caption = dict["caption"] as? String else {
                return
            }
            guard let creationDate = dict["creationDate"] as? NSNumber else {
                return
            }
            guard let imageHeight = dict["imageHeight"] as? CGFloat else {
                return
            }
            guard let imageWidth = dict["imageWidth"] as? CGFloat else {
                return
            }
            guard let imageUrl = dict["caption"] as? String else {
                return
            }
            
            let post = Post(caption: caption, imageHeight: imageHeight , imageWidth: imageWidth, imageUrl: imageUrl, creationDate: creationDate)
            print(post)
            self.currentUserPosts.append(post)
            
            DispatchQueue.main.async {
                self.collectionView?.reloadData()
            }
            
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
        return header
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
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath)
        cell.backgroundColor = .purple
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = (view.frame.width - 2) / 3
        return CGSize(width: width, height: width)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 1
    }
    
    fileprivate func fetchUser(){
        guard let UID = Auth.auth().currentUser?.uid else {
            return
        }
        self.currentUserID = UID
        
        Database.database().reference().child("users").child(UID).observeSingleEvent(of: .value, with: { (snapshot) in
            
            
            if let dict = snapshot.value as? [String: Any] {
                 self.user = User(dictionary: dict)
                self.navigationItem.title = self.user?.username
            }
            self.collectionView?.reloadData()
            
        }) { (error) in
            print(error.localizedDescription)
        }
        
    }
    
}
