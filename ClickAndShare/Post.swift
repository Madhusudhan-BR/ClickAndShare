//
//  Post.swift
//  ClickAndShare
//
//  Created by Madhusudhan B.R on 7/15/17.
//  Copyright © 2017 Madhusudhan. All rights reserved.
//

import UIKit

class  Post: NSObject {
    var caption: String?
    var imageHeight: CGFloat?
    var imageWidth: CGFloat?
    var imageUrl: String?
    var creationDate: NSNumber?
    var user: User
    
    init(user: User,caption: String, imageHeight: CGFloat, imageWidth: CGFloat, imageUrl: String, creationDate: NSNumber) {
        self.caption = caption
        self.imageHeight = imageHeight
        self.imageWidth = imageWidth
        self.imageUrl = imageUrl
        self.creationDate = creationDate
        self.user = user
    }
}
