//
//  SearchCell.swift
//  ClickAndShare
//
//  Created by Madhusudhan B.R on 7/19/17.
//  Copyright © 2017 Madhusudhan. All rights reserved.
//

import UIKit

class SearchCell: UICollectionViewCell {
   
    let profileImageView : CustomImageView = {
        let iv = CustomImageView()
        iv.layer.cornerRadius = 20
        iv.backgroundColor = .white
        iv.contentMode = .scaleAspectFill
        iv.clipsToBounds = true
        return iv
    }()
    
    var usernameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 14)
        label.text = "Username"
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(profileImageView)
        addSubview(usernameLabel)
        
        profileImageView.anchor(top: nil, left: leftAnchor, bottom: nil, right: nil, paddingTop: 8, paddingLeft: 8, paddingBottom: 0, paddingRight: 0, width: 40, height: 40)
        profileImageView.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        
        usernameLabel.anchor(top: profileImageView.topAnchor, left: profileImageView.rightAnchor, bottom: nil, right: rightAnchor, paddingTop: 0, paddingLeft: 8, paddingBottom: 0, paddingRight: 0, width: 0, height: 0)
        let seperatorView = UIView()
        seperatorView.backgroundColor = UIColor(white: 0, alpha: 0.5)
        addSubview(seperatorView)
        seperatorView.anchor(top: bottomAnchor, left: usernameLabel.leftAnchor, bottom: nil, right: rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 0.5)
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
}
