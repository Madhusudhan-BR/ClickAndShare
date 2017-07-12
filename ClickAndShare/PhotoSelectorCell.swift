//
//  PhotoSelectorCell.swift
//  ClickAndShare
//
//  Created by Madhusudhan B.R on 7/12/17.
//  Copyright © 2017 Madhusudhan. All rights reserved.
//

import UIKit

class PhotoSelectorCell : UICollectionViewCell {
    
    let imageView : UIImageView = {
        let iv = UIImageView()
        
        return iv
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame )
        
        addSubview(imageView)
        imageView.anchor(top: topAnchor, left: leftAnchor, bottom: bottomAnchor, right: rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 0)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
