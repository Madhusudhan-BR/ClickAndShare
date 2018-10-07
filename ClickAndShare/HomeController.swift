//
//  HomeController.swift
//  ClickAndShare
//
//  Created by Madhusudhan B.R on 7/18/17.
//  Copyright © 2017 Madhusudhan. All rights reserved.
//

import UIKit
import Firebase
import MessageUI

var blockedUsers = [String]()

class HomeController: UICollectionViewController, UICollectionViewDelegateFlowLayout, HomeFeedDelegate,  MFMailComposeViewControllerDelegate,HomeFeedDelegate2 {
    
    let cellID = "cell"
    var Posts = [Post]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
     
        setupNavigationBarItems()
        collectionView?.backgroundColor = UIColor.white
        collectionView?.register(HomeFeedCell.self, forCellWithReuseIdentifier: cellID)
        collectionView?.register(HomeFeedCell2.self, forCellWithReuseIdentifier: "cellId2")
        NotificationCenter.default.addObserver(self, selector: #selector(handleUpdate), name: ShareController.notificationName, object: nil)
        fetchAll()
        let refreshControl = UIRefreshControl()
        collectionView?.refreshControl = refreshControl
        refreshControl.addTarget(self, action: #selector(handleRefresh), for: .valueChanged)
    }
    
    func setupNavigationBarItems(){
        navigationItem.title = "ClickAndShare"
//        self.navigationController?.navigationBar.titleTextAttributes =
//            [NSForegroundColorAttributeName: UIColor.black,
//             NSFontAttributeName: UIFont(name: "Comic-Sans-MS", size: 21)!]
        navigationItem.titleView?.tintColor = .black
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: #imageLiteral(resourceName: "ic_photo_camera_2x").imageColor(color: UIColor.white).withRenderingMode(.alwaysOriginal), style: .plain, target: self, action: #selector(handleCamera))
    }
    
    func handleCamera() {
        let cameraController = CameraController()
        present(cameraController, animated: true, completion: nil)
    }
    func handleUpdate(){
        handleRefresh()
    }
    
    func handleRefresh(){
        Posts.removeAll()
        fetchAll()
    }
    
    fileprivate func fetchAll(){
        fetchPosts()
        fetchFollowingUserPosts()

    }
    
    func fetchFollowingUserPosts() {
        guard let currentUserUid = Auth.auth().currentUser?.uid else { return }
        Database.database().reference().child("follow").child(currentUserUid).observeSingleEvent(of: .value, with: { (snapshot) in
            guard let dict = snapshot.value as? [String: Any] else { return }
           
            dict.forEach({ (key,value) in
                Database.fetchuserWithUid(uid: key, completion: { (user) in
                    
                    if self.checkIfUserIsBlocked(userID: user.uid) {
                        self.fetchPostsWithUser(user: user)
                    }
                    
                    
                    
                })
            })
        }) { (error) in
            print(error)
        }
    }
    
    
    func checkIfUserIsBlocked(userID: String) -> Bool {
        let defaults = UserDefaults.standard
        // var blockedList = [User]()
        
        if let  blockedList = defaults.object(forKey: "blockedUsersID") as? [String] {
            print(blockedList)
            for blockedUser in blockedList {
                if userID == blockedUser{
                    print("returned false")
                    return false
                }
                else {
                    return true
                }
            }
            
        }
            return true
    }

    
    func fetchPosts() {
        
        guard let currentuserID = Auth.auth().currentUser?.uid else {
            return }
        
        Database.fetchuserWithUid(uid: currentuserID) { (user) in
            self.fetchPostsWithUser(user: user)
        }
        
    }
   
    fileprivate func fetchPostsWithUser(user: User) {
       Posts.removeAll()
        let postsRef = Database.database().reference().child("posts").child(user.uid)
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
                guard let key = eachDict.key as? String else { return }
                
                let post = Post(user: user, caption: caption, imageHeight: imageHeight , imageWidth: imageWidth, imageUrl: imageUrl, creationDate: creationDate, postId: key)
                guard let uid = Auth.auth().currentUser?.uid else { return }
                Database.database().reference().child("likes").child(key).observeSingleEvent(of: .value, with: { (likessnap) in
                    guard  let numofLikes = likessnap.children.allObjects.count as? Int else { return }
                    post.numofLikes = numofLikes
                }, withCancel: { (error) in
                    print(error)
                })
                Database.database().reference().child("comments").child(key).observeSingleEvent(of: .value, with: { (commentsnap) in
                    guard  let numofComments = commentsnap.children.allObjects.count as? Int else { return }
                    post.numofComments = numofComments
                }, withCancel: { (error) in
                    print(error)
                })
                Database.database().reference().child("likes").child(key).child(uid).observeSingleEvent(of: .value, with: { (snapshot) in
                    if let value = snapshot.value as? Int, value == 1 {
                        post.hasLiked = true
                    }
                    else {
                        post.hasLiked = false
                    }
                    
                    self.Posts.append(post)
                    self.Posts.sort(by: { (p1, p2) -> Bool in
                        return p1.creationDate?.compare(p2.creationDate!) == .orderedDescending
                    })
                    
                    self.collectionView?.reloadData()
                }, withCancel: { (error) in
                    print(error)
                })
                
                
            }
            
            
            
            self.collectionView?.refreshControl?.endRefreshing()
//            DispatchQueue.main.async {
//                self.collectionView?.reloadData()
//            }
            
            
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
        
//        let frame = CGRect(x: 0, y: 0, width: view.frame.width, height: 60)
//        let dummycell = HomeFeedCell(frame: frame)
//        dummycell.post = Posts[indexPath.item]
//        dummycell.layoutIfNeeded()
//        let targetSize = CGSize(width: view.frame.width, height: 1000)
//        let estimatedSize = dummycell.systemLayoutSizeFitting(targetSize)
//        let height = max(60, 2*estimatedSize.height)
        
        let post = Posts[indexPath.item]
        var height:CGFloat = 0
        if post.imageUrl == "none" {
            height = 56.0+50.0 + 50.0

        } else {
            height = 56.0+50.0 + 50.0
            height += view.frame.width
        }
        return CGSize(width: view.frame.width, height: height)
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        guard let post = Posts[indexPath.item] as? Post else { return UICollectionViewCell() }
        
        if post.imageUrl == "none"{
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cellId2", for: indexPath) as! HomeFeedCell2
            
            cell.post = post
            cell.delegate2 = self
            return cell
        } else {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellID, for: indexPath) as! HomeFeedCell
            
            cell.post = post
            cell.delegate = self
            return cell
        }

    }
    
    
    
    func loadCommentsController2(post: Post) {
        print("Print from controller")
        let commentsController = CommentsController(collectionViewLayout: UICollectionViewFlowLayout())
        commentsController.post = post
        navigationController?.pushViewController(commentsController, animated: true)
    }
    
    func didTapLike2(for cell: HomeFeedCell2) {
        guard let index = collectionView?.indexPath(for: cell) else { return }
        let post = Posts[index.item]
        guard let postId = post.postId else { return }
        guard let userId = Auth.auth().currentUser?.uid else { return }
        let values = [ userId: post.hasLiked == true ? 0 : 1]
        Database.database().reference().child("likes").child(postId).updateChildValues(values) { (error, ref) in
            if let error = error {
                print(error)
                return
            }
            print("liked")
            post.hasLiked = !post.hasLiked
            self.Posts[index.item] = post
            self.collectionView?.reloadItems(at: [index])
        }
    }
    
    func didTapOptions2(post: Post) {
        let alert = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        let reportAction = UIAlertAction(title: "Report", style: .destructive) { (_) in
            var mailComposeVC = self.configureMailController(post: post)
            if MFMailComposeViewController.canSendMail() {
                self.present(mailComposeVC, animated: true, completion: nil)
            } else {
                self.showMailError()
            }
        }
        alert.addAction(cancelAction)
        alert.addAction(reportAction)
        alert.popoverPresentationController?.sourceView = self.view
        alert.popoverPresentationController?.permittedArrowDirections = []
        alert.popoverPresentationController?.sourceRect = CGRect(x: self.view.bounds.midX , y: self.view.bounds.midY , width: 0  , height: 0)
        
        present(alert, animated: true, completion: nil)
    }
    
    
    
    
    func loadCommentsController(post: Post) {
        print("Print from controller")
        let commentsController = CommentsController(collectionViewLayout: UICollectionViewFlowLayout())
        commentsController.post = post 
        navigationController?.pushViewController(commentsController, animated: true) 
    }
    
    func didTapLike(for cell: HomeFeedCell) {
        guard let index = collectionView?.indexPath(for: cell) else { return }
        let post = Posts[index.item]
        guard let postId = post.postId else { return }
        guard let userId = Auth.auth().currentUser?.uid else { return }
        let values = [ userId: post.hasLiked == true ? 0 : 1]
        Database.database().reference().child("likes").child(postId).updateChildValues(values) { (error, ref) in
            if let error = error {
                print(error)
                return
            }
            print("liked")
            post.hasLiked = !post.hasLiked
            self.Posts[index.item] = post
            self.collectionView?.reloadData()
        }
    }
    
    func didTapOptions(post: Post) {
        let alert = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        let reportAction = UIAlertAction(title: "Report", style: .destructive) { (_) in
            var mailComposeVC = self.configureMailController(post: post)
            if MFMailComposeViewController.canSendMail() {
                self.present(mailComposeVC, animated: true, completion: nil)
            } else {
                self.showMailError()
            }
        }
        alert.addAction(cancelAction)
        alert.addAction(reportAction)
        alert.popoverPresentationController?.sourceView = self.view
        alert.popoverPresentationController?.permittedArrowDirections = []
        alert.popoverPresentationController?.sourceRect = CGRect(x: self.view.bounds.midX , y: self.view.bounds.midY , width: 0  , height: 0)

        present(alert, animated: true, completion: nil)
    }
    
    
    func showMailError() {
        createAlert(title: "Could not send mail", message: "Your device could not send an email to the developer")
    }
    
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        if error != nil {
            return
        }
        controller.dismiss(animated: true, completion: nil)
        switch  result {
        case .sent:
            createAlert(title: "Success", message: "The developer will look into the matter within 24 hours")
            break
        default : break
        }
        
        //self.navigationController?.popViewController(animated: true)
    }
    
    func configureMailController(post: Post) -> MFMailComposeViewController {
        let mailComposerVC = MFMailComposeViewController()
        mailComposerVC.mailComposeDelegate = self
        mailComposerVC.setToRecipients(["brmadhusudhan@gmail.com"])
        mailComposerVC.setSubject("Report Spam")
        mailComposerVC.setMessageBody("Hi, I am experiencing spam from the user whose name is \(post.user.username) and UID is \(post.user.uid) with regard to the post \(post.postId). Please look into the matter. Thank you", isHTML: false)
        return mailComposerVC
    }
    
    
    func createAlert(title: String, message: String) {
        let alert = UIAlertController(
            title: title,
            message: message,
            preferredStyle: UIAlertControllerStyle.alert
        )
        
        alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
        
        present(alert, animated: true, completion: nil)
    }
}
