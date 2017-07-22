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
            let attributedText = NSMutableAttributedString(string: comment?.user?.username ?? "" , attributes: [NSFontAttributeName: UIFont.boldSystemFont(ofSize: 14)])
            attributedText.append(NSAttributedString(string:  " " + (comment?.text)! , attributes: [NSFontAttributeName: UIFont.systemFont(ofSize: 14)]))
            self.commentView.attributedText = attributedText
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
    
    var commentView: UITextView = {
        let tv = UITextView()
        tv.isScrollEnabled = false
        tv.isEditable = false
        tv.font = UIFont.systemFont(ofSize: 14)
        //tv.numberOfLines = 0
        //tv.text = "This is a comment. i am testing the comment. Do you realise this may go to the next line now?"
        return tv
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(profileImageView)
        addSubview(commentView)
        profileImageView.anchor(top: topAnchor, left: leftAnchor, bottom: nil, right: nil, paddingTop: 8, paddingLeft: 8, paddingBottom: 0, paddingRight: 0, width: 40, height: 40)
        commentView.anchor(top: topAnchor ,left: profileImageView.rightAnchor, bottom: bottomAnchor, right: rightAnchor, paddingTop: 8, paddingLeft: 8, paddingBottom: -8, paddingRight: 8, width: 0, height: 0)
        
        let seperatorView = UIView()
        seperatorView.backgroundColor = UIColor(white: 0, alpha: 0.3)
        addSubview(seperatorView)
        seperatorView.anchor(top: bottomAnchor, left: commentView.leftAnchor, bottom: nil, right: rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 0.5)
        
        
       
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
