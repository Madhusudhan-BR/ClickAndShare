//
//  HomeFeedCell2.swift
//  ClickAndShare
//
//  Created by Madhusudhan B.R on 7/18/17.
//  Copyright © 2017 Madhusudhan. All rights reserved.
//

import UIKit

protocol  HomeFeedDelegate2 {
    func loadCommentsController2(post: Post)
    func didTapLike2(for cell: HomeFeedCell2)
    func didTapOptions2(post: Post)
}

class HomeFeedCell2: UICollectionViewCell {
    var delegate2: HomeFeedDelegate2?
    
    var post: Post? {
        didSet {
            likeButton.setImage(post?.hasLiked == true ? #imageLiteral(resourceName: "like_selected").imageColor(color: blueColor).withRenderingMode(.alwaysOriginal): #imageLiteral(resourceName: "like_unselected").imageColor(color: blueColor).withRenderingMode(.alwaysOriginal), for: .normal)
            usernameLabel.text = post?.user.username
            profileImageView.loadImage(urlString: post?.user.profileImageURL ?? "")
            setupAttributedText()
            numofLikesLabel.text = "•\(post!.numofLikes) Likes"
            numofCommentsLabel.text = "•\(post!.numofComments) Comments  • \(post!.date.timeAgoDisplay())"
        }
    }
    
    var numofLikesLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14)
        label.text = "3 likes"
        label.textColor = UIColor.lightGray
        return label
    }()
    
    var numofCommentsLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14)
        label.textColor = UIColor.lightGray
        label.text = "4 comments"
        return label
    }()

    
    func setupAttributedText(){
        let attributedText = NSMutableAttributedString(string: "", attributes: [NSFontAttributeName : UIFont.boldSystemFont(ofSize: 14)])
        attributedText.append(NSAttributedString(string: "\(post!.caption!)", attributes: [NSFontAttributeName: UIFont.boldSystemFont(ofSize: 14)]))
        attributedText.append(NSAttributedString(string: "", attributes: [NSFontAttributeName: UIFont.systemFont(ofSize: 14), NSForegroundColorAttributeName: UIColor.lightGray]))
        
        captionLabel.attributedText = attributedText
        
    }
    
    let profileImageView : CustomImageView = {
        let iv = CustomImageView()
        
        iv.layer.cornerRadius = 4
        iv.contentMode = .scaleAspectFill
        iv.clipsToBounds = true
        return iv
    }()
    
    lazy var optionsButton: UIButton = {
        let options = UIButton(type: .system)
        options.setTitle("•••", for: .normal)
        options.setTitleColor(UIColor.black, for: .normal)
        options.addTarget(self, action: #selector(handleOptions), for: .touchUpInside)
        return options
    }()
    
    func handleOptions() {
        
        guard let post = self.post else { return}
        delegate2?.didTapOptions2(post: post)
        
    }
    
    lazy var likeButton: UIButton = {
        let options = UIButton(type: .system)
        options.setImage(#imageLiteral(resourceName: "like_unselected").withRenderingMode(.alwaysOriginal), for: .normal)
        options.addTarget(self, action: #selector(handleLikes), for: .touchUpInside)
        options.setTitleColor(UIColor.black, for: .normal)
        return options
    }()
    
    func handleLikes(){
        delegate2?.didTapLike2(for: self)
    }
    
    lazy var commentButton: UIButton = {
        let options = UIButton(type: .system)
        options.setImage(#imageLiteral(resourceName: "comment").imageColor(color: blueColor).withRenderingMode(.alwaysOriginal), for: .normal)
        options.addTarget(self, action: #selector(handleComments), for: .touchUpInside)
        options.setTitleColor(UIColor.black, for: .normal)
        return options
    }()
    
    func handleComments(){
        print("Trying to post comments")
        guard  let post = self.post else {
            return
        }
        delegate2?.loadCommentsController2(post: post)
    }
    
    var usernameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 14)
        label.text = "Username"
        label.textColor = blueColor
        return label
    }()
    
    let captionLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 14)
        label.numberOfLines = 0
        return label
    }()
    

    var likesCommentsStackView: UIStackView?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        
        addSubview(usernameLabel)
        addSubview(optionsButton)
        addSubview(profileImageView)
        addSubview(captionLabel)
        addSubview(numofLikesLabel)
        addSubview(numofCommentsLabel)
        
        likesCommentsStackView = UIStackView(arrangedSubviews: [numofLikesLabel,numofCommentsLabel])
        stackView?.axis = .horizontal
        stackView?.distribution = .fillEqually
        
        addSubview(likesCommentsStackView!)
        
        //        profileImageView.anchor(top: topAnchor, left: leftAnchor, bottom: ImageView.topAnchor, right: nil, paddingTop: 8, paddingLeft: 8, paddingBottom: -8, paddingRight: 0, width: 40, height: 40)
        //        optionsButton.anchor(top: topAnchor, left: usernameLabel.rightAnchor, bottom: ImageView.topAnchor, right: rightAnchor, paddingTop: 8, paddingLeft: 0, paddingBottom: -8, paddingRight: 8, width: 44, height: 0)
        //        usernameLabel.anchor(top: topAnchor, left: profileImageView.rightAnchor, bottom: ImageView.topAnchor, right: optionsButton.leftAnchor, paddingTop: 8, paddingLeft: 8, paddingBottom: -8, paddingRight: 0, width: 0, height: 0)
        //        ImageView.anchor(top: profileImageView.bottomAnchor, left: leftAnchor, bottom: nil, right: rightAnchor, paddingTop: 0, paddingLeft: 8, paddingBottom: 0, paddingRight: 8, width: 0, height: 0)
        //        ImageView.heightAnchor.constraint(equalTo: ImageView.widthAnchor, multiplier: 1).isActive = true
        //
        //        numofLikesLabel.anchor(top: stackView?.bottomAnchor, left: leftAnchor, bottom: numofCommentsLabel.topAnchor, right: rightAnchor, paddingTop: 8, paddingLeft: 8, paddingBottom: 0, paddingRight: 0, width: 0, height: 0)
        //        numofCommentsLabel.anchor(top: numofLikesLabel.bottomAnchor, left: leftAnchor, bottom: captionLabel.topAnchor, right: rightAnchor, paddingTop: 8, paddingLeft: 8, paddingBottom: 0, paddingRight: 0, width: 0, height: 0)
        //
        //        captionLabel.anchor(top: numofCommentsLabel.bottomAnchor, left: leftAnchor, bottom: bottomAnchor, right: rightAnchor, paddingTop: 0, paddingLeft: 8, paddingBottom: 0, paddingRight: 8, width: 0, height: 0)
        //        setupActionButtons()
        
        profileImageView.anchor(top: topAnchor, left: leftAnchor, bottom: captionLabel.topAnchor, right: nil, paddingTop: 8, paddingLeft: 8, paddingBottom: -8, paddingRight: 0, width: 40, height: 40)
        
        optionsButton.anchor(top: topAnchor, left: usernameLabel.rightAnchor, bottom: captionLabel.topAnchor, right: rightAnchor, paddingTop: 8, paddingLeft: 0, paddingBottom: -8, paddingRight: 8, width: 44, height: 0)
        
        usernameLabel.anchor(top: topAnchor, left: profileImageView.rightAnchor, bottom: captionLabel.topAnchor, right: optionsButton.leftAnchor, paddingTop: 8, paddingLeft: 8, paddingBottom: -8, paddingRight: 0, width: 0, height: 0)
        captionLabel.anchor(top: profileImageView.bottomAnchor, left: leftAnchor, bottom: likesCommentsStackView?.topAnchor, right: rightAnchor, paddingTop: 0, paddingLeft: 8, paddingBottom: -8, paddingRight: 8, width: 0, height: 0)
       
        
        
        
        
        likesCommentsStackView?.anchor(top: captionLabel.bottomAnchor, left: leftAnchor, bottom: stackView?.topAnchor, right: nil, paddingTop: 8, paddingLeft: 8, paddingBottom: 0, paddingRight: 0, width: 250, height: 20)
        setupActionButtons()
        
    }
    
    var stackView: UIStackView?
    
    fileprivate func setupActionButtons() {
        stackView = UIStackView(arrangedSubviews: [likeButton,commentButton])
        stackView?.axis = .horizontal
        stackView?.distribution = .fillEqually
        
        addSubview(stackView!)
        stackView?.anchor(top: likesCommentsStackView?.bottomAnchor, left: leftAnchor, bottom: bottomAnchor, right: nil, paddingTop: 8, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 80, height: 40)
    }

    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
