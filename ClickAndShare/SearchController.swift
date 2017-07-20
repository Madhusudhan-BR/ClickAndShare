//
//  SearchController.swift
//  ClickAndShare
//
//  Created by Madhusudhan B.R on 7/19/17.
//  Copyright © 2017 Madhusudhan. All rights reserved.
//

import UIKit
import FirebaseDatabase
import FirebaseAuth


class SearchController : UICollectionViewController,UICollectionViewDelegateFlowLayout,UISearchBarDelegate  {
    
    let cellId = "cell"
    var users = [User]()
    var filteredUsers = [User]()
    
    lazy var searchBar: UISearchBar = {
        let sb = UISearchBar()
        sb.placeholder = "Enter search text"
        sb.delegate = self
        UITextField.appearance(whenContainedInInstancesOf:[UISearchBar.self]).backgroundColor = UIColor.rgb(red: 230, green: 230, blue: 230)
        return sb
    }()
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        filteredUsers = self.users.filter({ (user) -> Bool in
            return user.username.lowercased().contains(searchText.lowercased())
            
        })
        collectionView?.reloadData()
    }
    
    override func viewDidLoad() {
         super.viewDidLoad()
        
        collectionView?.register(SearchCell.self, forCellWithReuseIdentifier: cellId)
         collectionView?.backgroundColor = UIColor.white
        collectionView?.keyboardDismissMode = .interactive
        fetchUsers()
        collectionView?.alwaysBounceVertical = true 
        navigationController?.navigationBar.addSubview(searchBar)
        let navBar = navigationController?.navigationBar
        searchBar.anchor(top: navBar?.topAnchor, left: navBar?.leftAnchor, bottom: navBar?.bottomAnchor, right: navBar?.rightAnchor, paddingTop: 0, paddingLeft: 8, paddingBottom: 0, paddingRight: 8, width: 0, height: 0)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        searchBar.isHidden = false
    }
    
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return filteredUsers.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! SearchCell
        let user = filteredUsers[indexPath.item]
        cell.user = user
        return cell
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        searchBar.isHidden = true
        searchBar.resignFirstResponder()
        let userProfileController = UserProfileController(collectionViewLayout: UICollectionViewFlowLayout())
        userProfileController.userId = filteredUsers[indexPath.item].uid
        navigationController?.pushViewController(userProfileController, animated: true)
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: view.frame.width, height: 60)
    }
    
    fileprivate func fetchUsers(){
        let _ = Database.database().reference().child("users").observeSingleEvent(of: .value, with: { (snapshot) in
            guard let userDictionaries = snapshot.value as? [String: Any] else { return }
            userDictionaries.forEach({ (key,value) in
                guard let dict = value as? [String: Any] else { return }
                if key == Auth.auth().currentUser?.uid {
                    return
                }
                let user = User(uid: key, dictionary: dict)
                self.users.append(user)
                self.users.sort(by: { (user1, user2) -> Bool in
                    return user1.username.compare(user2.username) == .orderedAscending
                })
            })
            self.collectionView?.reloadData()
        }) { (error) in
            print(error)
            
        }
    }
    
    
}
