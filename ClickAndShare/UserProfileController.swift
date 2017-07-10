//
//  UserProfileController.swift
//  ClickAndShare
//
//  Created by Madhusudhan B.R on 7/10/17.
//  Copyright © 2017 Madhusudhan. All rights reserved.
//

import UIKit
import Firebase

class UserProfileController: UICollectionViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView?.backgroundColor = .white
        
        fetchUser()
    }
    
    fileprivate func fetchUser(){
        guard let UID = Auth.auth().currentUser?.uid else {
            return
        }
        
        Database.database().reference().child("users").child(UID).observeSingleEvent(of: .value, with: { (snapshot) in
            
            
            if let dict = snapshot.value as? [String: Any] {
                if let username = dict["username"] as? String {
                    self.navigationItem.title = username
                }
            }
            
        }) { (error) in
            print(error.localizedDescription)
        }
        
    }
    
}
