//
//  User.swift
//  ClickAndShare
//
//  Created by Madhusudhan B.R on 7/10/17.
//  Copyright © 2017 Madhusudhan. All rights reserved.
//

import Foundation

class User : NSObject {
    
    var username: String
    var profileImageURL : String
    
    
     init(dictionary : [String: Any]) {
        self.username = dictionary["username"] as? String ?? ""
        self.profileImageURL = dictionary["profileImageURL"] as? String ?? ""
        
    }
    
}
