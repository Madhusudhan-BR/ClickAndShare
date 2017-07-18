//
//  HomeFeedCell.swift
//  ClickAndShare
//
//  Created by Madhusudhan B.R on 7/18/17.
//  Copyright © 2017 Madhusudhan. All rights reserved.
//

import UIKit

class HomeFeedCell: UICollectionViewCell {
    
    var post: Post? {
        didSet {
            ImageView.loadImage(urlString: post?.imageUrl ?? "")
        }
    }
    
    let profileImageView : CustomImageView = {
        let iv = CustomImageView()
        iv.backgroundColor = UIColor.green
        iv.layer.cornerRadius = 20
        iv.contentMode = .scaleAspectFill
        iv.clipsToBounds = true
        return iv
    }()
    
    let optionsButton: UIButton = {
        let options = UIButton(type: .system)
        options.setTitle("•••", for: .normal)
        options.setTitleColor(UIColor.black, for: .normal)
        return options
    }()
   
    let likeButton: UIButton = {
        let options = UIButton(type: .system)
        options.setImage(#imageLiteral(resourceName: "like_unselected").withRenderingMode(.alwaysOriginal), for: .normal)
        options.setTitleColor(UIColor.black, for: .normal)
        return options
    }()
    
    let commentButton: UIButton = {
        let options = UIButton(type: .system)
        options.setImage(#imageLiteral(resourceName: "comment").withRenderingMode(.alwaysOriginal), for: .normal)
        options.setTitleColor(UIColor.black, for: .normal)
        return options
    }()
    
    let usernameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 14)
        label.text = "Username"
        return label
    }()
    
    let commentLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 14)
        let attributedText = NSMutableAttributedString(string: "Username", attributes: [NSFontAttributeName : UIFont.boldSystemFont(ofSize: 14)])
        attributedText.append(NSAttributedString(string: "  This is a small caption", attributes: [NSFontAttributeName: UIFont.systemFont(ofSize: 14)]))
        attributedText.append(NSAttributedString(string: "\n1 week ago", attributes: [NSFontAttributeName: UIFont.systemFont(ofSize: 14), NSForegroundColorAttributeName: UIColor.lightGray]))

        label.attributedText = attributedText
        label.numberOfLines = 0
        return label
    }()
    
    let ImageView : CustomImageView = {
        let iv = CustomImageView()
        iv.contentMode = .scaleAspectFill
        iv.clipsToBounds = true
        return iv
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addSubview(ImageView)
        addSubview(usernameLabel)
        addSubview(optionsButton)
        addSubview(profileImageView)
        addSubview(commentLabel)
        profileImageView.anchor(top: topAnchor, left: leftAnchor, bottom: ImageView.topAnchor, right: nil, paddingTop: 8, paddingLeft: 8, paddingBottom: -8, paddingRight: 0, width: 40, height: 40)
        optionsButton.anchor(top: topAnchor, left: usernameLabel.rightAnchor, bottom: ImageView.topAnchor, right: rightAnchor, paddingTop: 8, paddingLeft: 0, paddingBottom: -8, paddingRight: 8, width: 44, height: 0)
        usernameLabel.anchor(top: topAnchor, left: profileImageView.rightAnchor, bottom: ImageView.topAnchor, right: optionsButton.leftAnchor, paddingTop: 8, paddingLeft: 8, paddingBottom: -8, paddingRight: 0, width: 0, height: 0)
        ImageView.anchor(top: profileImageView.bottomAnchor, left: leftAnchor, bottom: nil, right: rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 0)
        ImageView.heightAnchor.constraint(equalTo: ImageView.widthAnchor, multiplier: 1).isActive = true
        commentLabel.anchor(top: stackView?.bottomAnchor, left: leftAnchor, bottom: bottomAnchor, right: rightAnchor, paddingTop: 0, paddingLeft: 8, paddingBottom: 0, paddingRight: 8, width: 0, height: 0)
        setupActionButtons()
    }
    
    var stackView: UIStackView?
    
    fileprivate func setupActionButtons() {
        stackView = UIStackView(arrangedSubviews: [likeButton,commentButton])
        stackView?.axis = .horizontal
        stackView?.distribution = .fillEqually
        
        addSubview(stackView!)
        stackView?.anchor(top: ImageView.bottomAnchor, left: leftAnchor, bottom: commentLabel.topAnchor, right: nil, paddingTop: 8, paddingLeft: 0, paddingBottom: -8, paddingRight: 0, width: 80, height: 40)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
