//
//  UserProfileHeader.swift
//  ClickAndShare
//
//  Created by Madhusudhan B.R on 7/10/17.
//  Copyright © 2017 Madhusudhan. All rights reserved.
//

import UIKit
import FirebaseAuth
import FirebaseDatabase

protocol  UserProfileDelegate {
    func didTapGrid()
    func didTapList()
    func didTapBookmark()
    func didTapEditProfileButton()
}

class UserProfileHeader: UICollectionViewCell {
    var delegate : UserProfileDelegate?
    var user : User? {
        didSet {
            //setupProfileImage()
            guard  let url = user?.profileImageURL  else {
                return
            }
            setupEditProfileFolloeButton()
            
            self.profileImageView.loadImage(urlString: url)
            usernameLabel.text = user?.username
            let attributedText = NSMutableAttributedString(string: "\(user?.posts == nil ? 0 : user!.posts!)\n", attributes: [NSFontAttributeName : UIFont.boldSystemFont(ofSize: 14)])
            attributedText.append(NSAttributedString(string: "Posts", attributes: [NSForegroundColorAttributeName : UIColor.lightGray , NSFontAttributeName : UIFont.boldSystemFont(ofSize: 14)]))
            postsLabel.attributedText = attributedText
            
            let followingattributedText = NSMutableAttributedString(string: "\(user?.following == nil ? 0 : user!.following!)\n", attributes: [NSFontAttributeName : UIFont.boldSystemFont(ofSize: 14)])
            followingattributedText.append(NSAttributedString(string: "Following", attributes: [NSForegroundColorAttributeName : UIColor.lightGray , NSFontAttributeName : UIFont.boldSystemFont(ofSize: 14)]))
            followingLabel.attributedText = followingattributedText
            
            
            let followersattributedText = NSMutableAttributedString(string: "\(user?.followers == nil ? 0 : user!.followers!)\n", attributes: [NSFontAttributeName : UIFont.boldSystemFont(ofSize: 14)])
            followersattributedText.append(NSAttributedString(string: "Followers", attributes: [NSForegroundColorAttributeName : UIColor.lightGray , NSFontAttributeName : UIFont.boldSystemFont(ofSize: 14)]))
            
            followersLabel.attributedText = followersattributedText
            
            followersLabel.isHidden = true
        }
    }
    
    fileprivate func setupEditProfileFolloeButton() {
        guard let currentLoggedinUserId = Auth.auth().currentUser?.uid else { return }
        if user?.uid == currentLoggedinUserId {
            editProfileFollowButton.setTitle("Edit Profile", for: .normal)
            return
        }
        Database.database().reference().child("follow").child(currentLoggedinUserId).child(user!.uid).observeSingleEvent(of: .value, with: { (snapshot) in
            print(self.user?.uid ?? "",self.user?.username ?? "")
            if let isFollowing = snapshot.value as? String, isFollowing == "1" {
                self.editProfileFollowButton.setTitle("Unfollow", for: .normal)
                self.editProfileFollowButton.backgroundColor = UIColor.white
                self.editProfileFollowButton.layer.borderColor = UIColor.black.cgColor
                self.editProfileFollowButton.setTitleColor(UIColor.black, for: .normal)

            } else {
                self.editProfileFollowButton.setTitle("Follow", for: .normal)
                self.editProfileFollowButton.backgroundColor = blueColor    //UIColor.rgb(red: 17, green: 154, blue: 237)
                self.editProfileFollowButton.layer.borderColor = blueColor.cgColor
                self.editProfileFollowButton.setTitleColor(UIColor.white, for: .normal)

            }
        }) { (error) in
            print(error)
        }
        
       
        
    }
    
    let usernameLabel : UILabel = {
        let label = UILabel()
        label.text = "username"
        label.font = UIFont.boldSystemFont(ofSize: 14)
        return label
    }()
   
    let postsLabel : UILabel = {
        let label = UILabel()
        
        
        let attributedText = NSMutableAttributedString(string: "0\n", attributes: [NSFontAttributeName : UIFont.boldSystemFont(ofSize: 14)])
        attributedText.append(NSAttributedString(string: "Posts", attributes: [NSForegroundColorAttributeName : UIColor.lightGray , NSFontAttributeName : UIFont.boldSystemFont(ofSize: 14)]))
        
        label.attributedText = attributedText
        //label.text = "11\nPosts"
        label.numberOfLines = 0
        label.textAlignment = .center
        return label
    }()
    
    let followersLabel : UILabel = {
        let label = UILabel()
        let attributedText = NSMutableAttributedString(string: "0\n", attributes: [NSFontAttributeName : UIFont.boldSystemFont(ofSize: 14)])
        attributedText.append(NSAttributedString(string: "Followers", attributes: [NSForegroundColorAttributeName : UIColor.lightGray , NSFontAttributeName : UIFont.boldSystemFont(ofSize: 14)]))
        
        label.attributedText = attributedText
        
        label.numberOfLines = 0

        label.textAlignment = .center
        return label
    }()
    
    let followingLabel : UILabel = {
        let label = UILabel()
        let attributedText = NSMutableAttributedString(string: "0\n", attributes: [NSFontAttributeName : UIFont.boldSystemFont(ofSize: 14)])
        attributedText.append(NSAttributedString(string: "Following", attributes: [NSForegroundColorAttributeName : UIColor.lightGray , NSFontAttributeName : UIFont.boldSystemFont(ofSize: 14)]))
        
        label.attributedText = attributedText
        label.numberOfLines = 0

        label.textAlignment = .center
        return label
    }()
    
    
    let profileImageView : CustomImageView = {
        let iv = CustomImageView()
        iv.layer.cornerRadius = 4
        iv.layer.masksToBounds = true 
        return iv
    }()
    
    lazy var  gridButton : UIButton = {
        let button = UIButton(type: .system)
        button.setImage(#imageLiteral(resourceName: "grid"), for: .normal)
        button.addTarget(self, action: #selector(handleGrid), for: .touchUpInside)
        return button
    }()
    
    func handleGrid() {
        gridButton.tintColor = UIColor.rgb(red: 17, green: 154, blue: 237)
        listButton.tintColor = UIColor(white: 0, alpha: 0.1)
        delegate?.didTapGrid()
    }
    
    lazy var listButton : UIButton = {
        let button = UIButton(type: .system)
        button.setImage(#imageLiteral(resourceName: "list"), for: .normal)
        button.addTarget(self, action: #selector(handleList), for: .touchUpInside)
        button.tintColor = UIColor(white: 0, alpha: 0.1)
        return button
    }()
    
    func handleList() {
        listButton.tintColor = UIColor.rgb(red: 17, green: 154, blue: 237)
        gridButton.tintColor = UIColor(white: 0, alpha: 0.1)
        delegate?.didTapList()
    }
    
    
    lazy var bookmarkButton : UIButton = {
        let button = UIButton(type: .system)
        button.tintColor = UIColor(white: 0, alpha: 0.1)
        button.addTarget(self, action: #selector(handleBookmark), for: .touchUpInside)
        button.setImage(#imageLiteral(resourceName: "ribbon"), for: .normal)
        return button
    }()
    
    func handleBookmark() {
        delegate?.didTapBookmark()
    }
    
    
    
    lazy var editProfileFollowButton: UIButton = {
        let button = UIButton(type: .system)
        //button.setTitle("Edit button", for: .normal)
        button.setTitleColor(UIColor.black, for: .normal)
       button.layer.borderColor = UIColor.lightGray.cgColor
        button.layer.borderWidth = 1
        button.layer.cornerRadius = 3
        button.addTarget(self, action:#selector(handleEditProfileFollowButton), for: .touchUpInside)
        return button
    }()
    
    func handleEditProfileFollowButton() {
        
        guard let currentLoggedinUserId = Auth.auth().currentUser?.uid else { return }
        
        
        if editProfileFollowButton.titleLabel?.text == "Edit Profile" {
            delegate?.didTapEditProfileButton()
            
        } else if editProfileFollowButton.titleLabel?.text == "Follow" {
            
            
            let values = [(user?.uid)! : "1"]
            Database.database().reference().child("follow").child(currentLoggedinUserId).updateChildValues(values, withCompletionBlock: { (error, ref) in
                if let error = error {
                    print("unable to follow", error)
                }
                print("successfully followed user", self.user?.username ?? "")
                self.editProfileFollowButton.setTitle("Unfollow", for: .normal)
                self.editProfileFollowButton.backgroundColor = UIColor.white
                self.editProfileFollowButton.layer.borderColor = UIColor.black.cgColor
                self.editProfileFollowButton.setTitleColor(UIColor.black, for: .normal)
            })
            
        
        } else if editProfileFollowButton.titleLabel?.text == "Unfollow" {
            Database.database().reference().child("follow").child(currentLoggedinUserId).child(user!.uid).removeValue(completionBlock: { (error, ref) in
                if let error = error {
                    print("unable to unfollow", error)
                }
                print("unfollowed User", self.user?.username ?? "")
                self.editProfileFollowButton.setTitle("Follow", for: .normal)
                self.editProfileFollowButton.backgroundColor = blueColor//UIColor.rgb(red: 17, green: 154, blue: 237)
                self.editProfileFollowButton.layer.borderColor = blueColor.cgColor
                self.editProfileFollowButton.setTitleColor(UIColor.white, for: .normal)
            })
            
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(profileImageView)
        profileImageView.anchor(top: topAnchor, left: leftAnchor, bottom: nil, right: nil, paddingTop: 12, paddingLeft: 12, paddingBottom: 0, paddingRight: 0, width: 80, height: 80)

        setupButtonToolbar()
        
        addSubview(usernameLabel)
        usernameLabel.anchor(top: profileImageView.bottomAnchor, left: leftAnchor, bottom: gridButton.topAnchor, right: rightAnchor, paddingTop: 4, paddingLeft: 12, paddingBottom: 0, paddingRight: 12, width: 0, height: 0)
        
        setupUserStats()
        
        addSubview(editProfileFollowButton)
        editProfileFollowButton.anchor(top: postsLabel.bottomAnchor, left: profileImageView.rightAnchor, bottom: nil, right: rightAnchor, paddingTop: 4, paddingLeft: 12, paddingBottom: 0, paddingRight: 12, width: 0, height: 34)
        
        followersLabel.isHidden = true
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    fileprivate func setupUserStats() {
        let stackView = UIStackView(arrangedSubviews: [postsLabel, followersLabel, followingLabel])
        addSubview(stackView)
        stackView.axis = .horizontal
        stackView.distribution = .fillEqually
        
        stackView.anchor(top: topAnchor, left: profileImageView.rightAnchor , bottom: nil, right: self.rightAnchor, paddingTop: 12, paddingLeft: 12, paddingBottom: 0, paddingRight: 12, width: 0, height: 50)
        
        
    }
    
    fileprivate func setupButtonToolbar() {
        let topDividerView = UIView()
        topDividerView.backgroundColor = UIColor.lightGray
        
        let bottomDividerView = UIView()
        bottomDividerView.backgroundColor = UIColor.lightGray
        
        let stackView = UIStackView(arrangedSubviews: [gridButton, listButton])
        addSubview(stackView)
        stackView.axis = .horizontal
        stackView.distribution = .fillEqually
        
        stackView.anchor(top: nil, left: leftAnchor, bottom: self.bottomAnchor, right: self.rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 50)
        
        addSubview(topDividerView)
        topDividerView.anchor(top: stackView.topAnchor, left: leftAnchor, bottom: nil, right: rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 0.5)

        addSubview(bottomDividerView)
        bottomDividerView.anchor(top: stackView.bottomAnchor, left: leftAnchor, bottom: nil, right: rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 0.5)
        
        stackView.isHidden = true
        topDividerView.isHidden = true 
    }
    
  
    
}
