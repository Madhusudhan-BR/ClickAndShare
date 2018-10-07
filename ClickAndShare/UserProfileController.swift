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
    var onlyPicPosts = [Post]()
    var isGrid = false
    var isPagingDone = false
    var count = 0
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView?.backgroundColor = .white
        
        collectionView?.register(UserProfileHeader.self, forSupplementaryViewOfKind: UICollectionElementKindSectionHeader, withReuseIdentifier: "header")
        collectionView?.register(UserProfileCell.self, forCellWithReuseIdentifier: "cell")
        collectionView?.register(HomeFeedCell2.self, forCellWithReuseIdentifier: "homecell2")
        collectionView?.register(HomeFeedCell.self, forCellWithReuseIdentifier: "homecell")
        setupLogoutController()
        
        let refreshControl = UIRefreshControl()
        collectionView?.refreshControl = refreshControl
        refreshControl.addTarget(self, action: #selector(handleRefresh), for: .valueChanged)

        
        fetchUser()
        
    }
    
    func handleRefresh(){
        currentUserPosts.removeAll()
        onlyPicPosts.removeAll()
        fetchUser()
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
            //print("Print from function", snapshot.childrenCount)
            print("Print from function", allObjects.count)
            allObjects.reverse()
            
            if allObjects.count < 4 {
                self.isPagingDone = true
            }
            
            if self.currentUserPosts.count > 0 && allObjects.count > 0  {
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
                print("key",object.key)
//                self.currentUserPosts.insert(post, at: 0)
                self.currentUserPosts.append(post)
                

            }
            
           self.collectionView?.reloadData()
        }) { (error) in
            print(error.localizedDescription)
        }
    }
    
    fileprivate func observeMyPosts(){
        print("Start paging for more posts")
        
        guard let uid = self.user?.uid else { return }
        let ref = Database.database().reference().child("posts").child(uid)
        
        var query = ref.queryOrdered(byChild: "creationDate")
        
//        if currentUserPosts.count > 0 {
//            //            let value = posts.last?.id
//            let value = currentUserPosts.last?.creationDate
//            query = query.queryEnding(atValue: value)
//        }
        
        currentUserPosts.removeAll()
        onlyPicPosts.removeAll()
        
        query.observeSingleEvent(of: .value, with: { (snapshot) in
            
            guard var allObjects = snapshot.children.allObjects as? [DataSnapshot] else { return }
            
            allObjects.reverse()
            
//            if allObjects.count < 4 {
//                self.isPagingDone = true
//            }
//            
//            if self.currentUserPosts.count > 0 && allObjects.count > 0 {
//                allObjects.removeFirst()
//            }
            
            guard let user = self.user else { return }
            
            allObjects.forEach({ (object) in
                
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
                
                self.currentUserPosts.append(post)
                
                //                print(snapshot.key)
            })
            
            self.currentUserPosts.forEach({ (post) in
                if post.imageUrl == "none"{
                    self.count += 1
                } else {
                
                    self.onlyPicPosts.append(post)
                }
            })
            
            self.collectionView?.refreshControl?.endRefreshing()
            
            self.collectionView?.reloadData()
            
            
        }) { (err) in
            print("Failed to paginate for posts:", err)
        }
    }
    
    fileprivate func setupLogoutController() {
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: #imageLiteral(resourceName: "gear").imageColor(color: UIColor.white).withRenderingMode(.alwaysOriginal),  style: .plain, target: self, action: #selector(handleLogout))
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
        
        guard let UID = self.userId ?? (Auth.auth().currentUser?.uid ) else { return }
        guard let currentUserId = Auth.auth().currentUser?.uid else { return }
        
        if UID != currentUserId {
            alertController.addAction(UIAlertAction(title: "Block User", style: .destructive, handler: { (_) in
                
                let alert = UIAlertController(title: "Block", message: "Are you sure you want to block this user? If you block this user you can never see this user profile or posts", preferredStyle: .alert)
                let yesAction = UIAlertAction(title: "Yes", style: .destructive, handler: { (action) in
                    
                    
                    
                    blockedUsers.append(UID)

                    UserDefaults.standard.set(blockedUsers, forKey: "blockedUsersID")
                    
                    appdelegate.infoView(message: "Successfully blocked user. Refresh the application. ", color: greenColor)
                })
                let noAction = UIAlertAction(title: "No" ,style: .cancel, handler: nil)
                alert.addAction(yesAction)
                alert.addAction(noAction)
                self.present(alert, animated: true, completion: nil)

                
            })
        )}
        
        alertController.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        alertController.popoverPresentationController?.sourceView = self.view
        alertController.popoverPresentationController?.permittedArrowDirections = []
        alertController.popoverPresentationController?.sourceRect = CGRect(x: self.view.bounds.midX , y: self.view.bounds.midY , width: 0  , height: 0)
        

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
        if isGrid {
            return onlyPicPosts.count
        } else {
            return currentUserPosts.count
        }
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        //        if indexPath.item == self.currentUserPosts.count-1 && isPagingDone == false{
        //            self.observeMyPosts()
        //        }
        
        if isGrid {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! UserProfileCell
            let post = self.onlyPicPosts[indexPath.item]
            cell.imageView.loadImage(urlString: post.imageUrl ?? "")
            
            return cell
        }else {
            let post = currentUserPosts[indexPath.row]
            if post.imageUrl == "none" {
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "homecell2", for: indexPath) as! HomeFeedCell2
                
                cell.post = post
                cell.stackView?.isHidden = true
                cell.numofLikesLabel.isHidden = true
                cell.numofCommentsLabel.isHidden = true
                return cell
                
            }else {
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "homecell", for: indexPath) as! HomeFeedCell
                
                cell.post = post
                cell.stackView?.isHidden = true
                cell.numofLikesLabel.isHidden = true
                cell.numofCommentsLabel.isHidden = true
                return cell
                
            }
        }
        
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if isGrid  {
            let width = (view.frame.width - 2) / 3
            return CGSize(width: width, height: width)
        }
        else{
            var post = currentUserPosts[indexPath.item]
            if post.imageUrl == "none" {
                var height:CGFloat = 56.0+50.0 + 50.0
                return CGSize(width: view.frame.width, height: height)
                
            } else {
                var height:CGFloat = 56.0+50.0 + 50.0
                height += view.frame.width
                return CGSize(width: view.frame.width, height: height)
                
            }
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 1
    }
    
    fileprivate func fetchUser(){
//        guard let selfuid = self.userId else { return }
//        guard let current_user = Auth.auth().currentUser?.uid else { return }
        
        guard let UID = self.userId ?? (Auth.auth().currentUser?.uid ) else { return }
        self.currentUserID = UID
        
        Database.fetchuserWithUid(uid: UID) { (user) in
            
            
            Database.database().reference().child("follow").child(UID).observeSingleEvent(of: .value, with: { (snapshot) in
                let  follwingCount = Int(snapshot.childrenCount)
                user.following = follwingCount
            }) { (error) in
                print(error)
                return
            }
            
            let postsRef = Database.database().reference().child("posts").child(UID)
            
            postsRef.observeSingleEvent(of: .value, with: { (snapshot) in
                print(snapshot.childrenCount)
                let numberOfPosts =  Int(snapshot.childrenCount)
                user.posts = numberOfPosts
            }) { (error) in
                print(error)
            }
            var followersCount = 0
            
            Database.database().reference().child("follow").observeSingleEvent(of: .value, with: { (snapshot) in
                //print(snapshot.value)
                
                guard let allDict = snapshot.value as? [String: Any] else { return }
                for eachDict in allDict {
                    if eachDict.key != UID {
                        guard let dict = eachDict.value as? [String: Any] else { return }
                        print(UID,dict["\(UID)"])
                        if let value = dict["\(UID)"] as? String ,value == "1" {
                            followersCount += 1
                        }
                     }
                }
//                user.followers = followersCount
//                self.user = user
//                self.navigationItem.title = user.username
//                DispatchQueue.main.async {
//                self.collectionView?.reloadData()    
//                }
                
                self.observeMyPosts()
            }) { (error) in
                print(error)
            }
            
            user.followers = followersCount
            self.user = user
            self.navigationItem.title = user.username
            DispatchQueue.main.async {
                self.collectionView?.reloadData()
            }
          

        }
        
        
        
    }
    
    func didTapBookmark() {
        saveFeedack()
    }
    
    func didTapEditProfileButton() {
        saveFeedack()
    }
    
    func saveFeedack() {
        let label = UILabel()
        label.text = "Comming soon!"
        label.textAlignment = .center
        label.textColor = UIColor.white
        label.backgroundColor = UIColor(white: 0, alpha: 0.2)
        view.addSubview(label)
        label.frame = CGRect(x: 0, y: 0, width: 150, height: 80)
        label.center = view.center
        
        label.layer.transform = CATransform3DMakeScale(0, 0, 0)
        label.alpha = 0
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 0.5, options: .curveEaseOut, animations: {
            label.layer.transform = CATransform3DMakeScale(1, 1, 1)
            label.alpha = 1
        }, completion: { (completed) in
            UIView.animate(withDuration: 0.5, delay: 0.75, usingSpringWithDamping: 0.5, initialSpringVelocity: 0.5, options: .curveEaseOut, animations: {
                label.layer.transform = CATransform3DMakeScale(0.1, 0.1, 0.1)
                label.alpha = 1
            }, completion: { (_) in
                label.removeFromSuperview()
            })
        })
        
    }
}
