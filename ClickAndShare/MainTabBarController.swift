//
//  MainTabBarController.swift
//  ClickAndShare
//
//  Created by Madhusudhan B.R on 7/10/17.
//  Copyright © 2017 Madhusudhan. All rights reserved.
//

import UIKit

class MainTabBarController: UITabBarController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        let userProfileController = UserProfileController(collectionViewLayout: UICollectionViewFlowLayout())
        let navigationController = UINavigationController(rootViewController: userProfileController)
        
       
        viewControllers = [navigationController]
    }
}
