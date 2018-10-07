//
//  CommentsController.swift
//  ClickAndShare
//
//  Created by Madhusudhan B.R on 7/22/17.
//  Copyright © 2017 Madhusudhan. All rights reserved.
//

import UIKit
import Firebase

class CommentsController: UICollectionViewController,UICollectionViewDelegateFlowLayout  {
    
    var comments = [Comment]()
    var post: Post?
    let cellId = "cell"
    let containerView: UIView = {
        let container = UIView()
        container.backgroundColor = UIColor.white
        return container
    }()
    
    lazy var  submitButton: UIButton = {
        let button = UIButton(type : .system)
        button.setTitle("Submit", for: .normal)
        button.addTarget(self, action: #selector(handleSubmit), for: .touchUpInside)
        return button
    }()
    
    func handleSubmit() {
        guard  let uid = Auth.auth().currentUser?.uid else {
            return
        }
        guard  let text = inpuTextField.text else {
            return
        }
        guard let  postId = self.post?.postId else {
            return
        }
        let values = ["uid": uid, "creationDate": Date().timeIntervalSince1970, "text": text] as [String: Any]
        
        Database.database().reference().child("comments").child(postId).childByAutoId().updateChildValues(values) { (error, ref) in
            if let error = error {
                print(error)
                return
            }
            self.inpuTextField.text = "" 
            print("uploaded post to db")
        }
    }
    
    let inpuTextField: UITextField = {
        let tf = UITextField()
        tf.placeholder = "Enter a comment"
        return tf
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "Comments"
        collectionView?.alwaysBounceVertical = true
        collectionView?.keyboardDismissMode = .interactive
        collectionView?.register(CommentCell.self ,forCellWithReuseIdentifier: cellId)
        collectionView?.backgroundColor = UIColor.white
        containerView.frame = CGRect(x: 0, y: 0, width: view.frame.width, height: 50)
        collectionView?.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: -50, right: 0)
        collectionView?.scrollIndicatorInsets = UIEdgeInsets(top: 0, left: 0, bottom: -50, right: 0) 
        containerView.addSubview(inpuTextField)
        containerView.addSubview(submitButton)
        inpuTextField.anchor(top: containerView.topAnchor, left: containerView.leftAnchor, bottom: containerView.bottomAnchor, right: submitButton.leftAnchor, paddingTop: 0, paddingLeft: 12, paddingBottom: 0, paddingRight: 12, width: 0, height: 0)
        
        submitButton.anchor(top: containerView.topAnchor, left: nil, bottom: containerView.bottomAnchor, right: containerView.rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 12, width: 60, height: 0)
        fetchComments()
    }
    

    
    func fetchComments(){
        guard let  postId = self.post?.postId else {
            return
        }
        Database.database().reference().child("comments").child(postId).observe(.childAdded, with: { (snapshot) in
            guard let commentDict = snapshot.value as? [String: Any] else {
                return
            }
            
            guard let userId = commentDict["uid"] as? String else {
                return 
            }
            Database.fetchuserWithUid(uid: userId) { (user) in
                let comment = Comment(id: snapshot.key, commentDictionary: commentDict)
                comment.user = user
                self.comments.append(comment)
                self.collectionView?.reloadData()
            }
        
        }) { (error) in
            print(error.localizedDescription)
        }
    }
    
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let frame = CGRect(x: 0, y: 0, width: view.frame.width, height: 60)
        let dummycell = CommentCell(frame: frame)
        dummycell.comment = comments[indexPath.item]
        dummycell.layoutIfNeeded()
        
        let targetSize = CGSize(width: view.frame.width, height: 1000)
        let estimatedSize = dummycell.systemLayoutSizeFitting(targetSize)
        let height = max(60, estimatedSize.height)
        return CGSize(width: view.frame.width, height: height)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return comments.count
    }
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! CommentCell
        let comment = comments[indexPath.item]
        cell.comment = comment
        return cell
    }
    
    override var inputAccessoryView: UIView? {
        get {
            return containerView
        }
    }
    
    override var canBecomeFirstResponder: Bool {
        return true
    }
    
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        tabBarController?.tabBar.isHidden = false
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tabBarController?.tabBar.isHidden = true
    }
    
    
    
}
