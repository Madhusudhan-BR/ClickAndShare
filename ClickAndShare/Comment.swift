//
//  Comment.swift
//  ClickAndShare
//
//  Created by Madhusudhan B.R on 7/22/17.
//  Copyright © 2017 Madhusudhan. All rights reserved.
//

import Foundation

class Comment: NSObject {
    
    var commentId: String?
    var creationDate: Double?
    var text: String?
    var uid: String?
    var  user: User?
    
    init(id: String, commentDictionary: [String: Any]) {
        self.creationDate = commentDictionary["creationDate"] as? Double
        self.text = commentDictionary["text"] as? String
        self.uid = commentDictionary["uid"]  as? String
        self.commentId = id 
    }

}
