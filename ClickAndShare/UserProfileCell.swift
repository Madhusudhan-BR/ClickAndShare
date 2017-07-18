//
//  UserProfileCell.swift
//  ClickAndShare
//
//  Created by Madhusudhan B.R on 7/18/17.
//  Copyright © 2017 Madhusudhan. All rights reserved.
//

import UIKit

class UserProfileCell : UICollectionViewCell {
    
    let imageView: CustomImageView = {
        let iv = CustomImageView()
        iv.contentMode = .scaleAspectFill
        iv.clipsToBounds  = true
        return iv
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(imageView)
        imageView.anchor(top: topAnchor, left: leftAnchor, bottom: bottomAnchor, right: rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 0)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
   func downloadImage(imageUrl: String){
  
    
    }
}
