//
//  CommentCell.swift
//  ClickAndShare
//
//  Created by Madhusudhan B.R on 7/22/17.
//  Copyright © 2017 Madhusudhan. All rights reserved.
//

import UIKit

class CommentCell: UICollectionViewCell {
    
    var comment:Comment? {
        didSet{
            self.profileImageView.loadImage(urlString: comment?.user?.profileImageURL ?? "")
            
            self.usernameLabel.text = comment?.user?.username
            print(comment?.user)
            self.commentLabel.text = comment?.text
        }
    }

    
    let profileImageView : CustomImageView = {
        let iv = CustomImageView()
        iv.layer.cornerRadius = 20
        iv.contentMode = .scaleAspectFill
        iv.clipsToBounds = true
        iv.backgroundColor = UIColor.red
        return iv
    }()
    
    
    var usernameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 14)
        label.text = "Username"
        return label
    }()
    
    var commentLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14)
        label.numberOfLines = 0
        label.text = "This is a comment. i am testing the comment. Do you realise this may go to the next line now?"
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(profileImageView)
        profileImageView.anchor(top: topAnchor, left: leftAnchor, bottom: nil, right: nil, paddingTop: 8, paddingLeft: 12, paddingBottom: 0, paddingRight: 0, width: 40, height: 40)
        
        addSubview(usernameLabel)
        usernameLabel.anchor(top: profileImageView.topAnchor, left: profileImageView.rightAnchor, bottom: profileImageView.bottomAnchor, right: rightAnchor, paddingTop: 0, paddingLeft: 12, paddingBottom: 0, paddingRight: 0, width: 0, height: 0)
        
        let seperatorView = UIView()
         addSubview(seperatorView)
        seperatorView.backgroundColor = UIColor(white: 0, alpha: 0.3)
        seperatorView.anchor(top: bottomAnchor, left: usernameLabel.leftAnchor, bottom: nil, right: rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 0.5)
        
        addSubview(commentLabel)
        commentLabel.anchor(top: usernameLabel.bottomAnchor, left: usernameLabel.leftAnchor, bottom: bottomAnchor, right: rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 0)
       
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
