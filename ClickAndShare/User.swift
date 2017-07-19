//
//  User.swift
//  ClickAndShare
//
//  Created by Madhusudhan B.R on 7/10/17.
//  Copyright © 2017 Madhusudhan. All rights reserved.
//

import Foundation

class User : NSObject {
    
    let username: String
    let profileImageURL : String
    let uid: String
    
    init(uid: String, dictionary : [String: Any]) {
        self.username = dictionary["username"] as? String ?? ""
        self.profileImageURL = dictionary["profileImageURL"] as? String ?? ""
        self.uid = uid
    }
    
}
