//
//  UserProfileController.swift
//  ClickAndShare
//
//  Created by Madhusudhan B.R on 7/10/17.
//  Copyright © 2017 Madhusudhan. All rights reserved.
//

import UIKit
import Firebase

class UserProfileController: UICollectionViewController, UICollectionViewDelegateFlowLayout {
    
    var user: User?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView?.backgroundColor = .white
        fetchUser()
        collectionView?.register(UserProfileHeader.self, forSupplementaryViewOfKind: UICollectionElementKindSectionHeader, withReuseIdentifier: "header")
    }
    

    
    override func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "header", for: indexPath) as! UserProfileHeader
        header.user = self.user 
        return header
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize(width: view.frame.width, height: 200)
    }
    
    
    fileprivate func fetchUser(){
        guard let UID = Auth.auth().currentUser?.uid else {
            return
        }
        
        Database.database().reference().child("users").child(UID).observeSingleEvent(of: .value, with: { (snapshot) in
            
            
            if let dict = snapshot.value as? [String: Any] {
                 self.user = User(dictionary: dict)
                self.navigationItem.title = self.user?.username
            }
            self.collectionView?.reloadData()
            
        }) { (error) in
            print(error.localizedDescription)
        }
        
    }
    
}
