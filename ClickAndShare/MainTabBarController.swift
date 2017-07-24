//
//  MainTabBarController.swift
//  ClickAndShare
//
//  Created by Madhusudhan B.R on 7/10/17.
//  Copyright © 2017 Madhusudhan. All rights reserved.
//

import UIKit
import Firebase

class MainTabBarController: UITabBarController, UITabBarControllerDelegate {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        if Auth.auth().currentUser?.uid == nil {
            
            
            let loginVC = LoginController()
            let navController = UINavigationController(rootViewController: loginVC)
            DispatchQueue.main.async {
                self.present(navController, animated: true, completion: nil)
            }
        }
        
        self.delegate = self
        
        initialSetup()
    }
    
    
    
    func tabBarController(_ tabBarController: UITabBarController, shouldSelect viewController: UIViewController) -> Bool {
        
        if  let index = viewControllers?.index(of: viewController) {
            if index == 2 {
                let photoSelectorVC = PhotoSelectorController(collectionViewLayout: UICollectionViewFlowLayout())
                let navController = UINavigationController(rootViewController: photoSelectorVC)
                present(navController, animated: true, completion: nil)
                return false
            }
            if index == 3 {
                saveFeedack()
                return false
            }
        }
        return true 
    }
    
    func saveFeedack() {
        let label = UILabel()
        label.text = "Comming soon!"
        label.textAlignment = .center
        label.textColor = UIColor.white
        label.backgroundColor = UIColor(white: 0, alpha: 0.2)
        view.addSubview(label)
        label.frame = CGRect(x: 0, y: 0, width: 150, height: 80)
        label.center = view.center
        
        label.layer.transform = CATransform3DMakeScale(0, 0, 0)
        label.alpha = 0
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 0.5, options: .curveEaseOut, animations: {
            label.layer.transform = CATransform3DMakeScale(1, 1, 1)
            label.alpha = 1
        }, completion: { (completed) in
            UIView.animate(withDuration: 0.5, delay: 0.75, usingSpringWithDamping: 0.5, initialSpringVelocity: 0.5, options: .curveEaseOut, animations: {
                label.layer.transform = CATransform3DMakeScale(0.1, 0.1, 0.1)
                label.alpha = 1
            }, completion: { (_) in
                label.removeFromSuperview()
            })
        })
        
    }

    
    func initialSetup(){
        
        let userProfileController = UserProfileController(collectionViewLayout: UICollectionViewFlowLayout())
        let userProfileNav = UINavigationController(rootViewController: userProfileController)
        userProfileNav.tabBarItem.selectedImage = #imageLiteral(resourceName: "profile_selected")
        userProfileNav.tabBarItem.image = #imageLiteral(resourceName: "profile_unselected")
        
        let homeNav = templateNavBarController(selectedImage: #imageLiteral(resourceName: "home_selected"), unselectedImage: #imageLiteral(resourceName: "home_unselected"),rootViewController: HomeController(collectionViewLayout: UICollectionViewFlowLayout()))
        let searchNav = templateNavBarController(selectedImage: #imageLiteral(resourceName: "search_selected"), unselectedImage: #imageLiteral(resourceName: "search_unselected"),rootViewController: SearchController(collectionViewLayout: UICollectionViewFlowLayout()))
        let addPostNav = templateNavBarController(selectedImage: #imageLiteral(resourceName: "plus_unselected"), unselectedImage: #imageLiteral(resourceName: "plus_unselected"))
        let likeNav = templateNavBarController(selectedImage: #imageLiteral(resourceName: "like_selected"), unselectedImage: #imageLiteral(resourceName: "like_unselected"))
        
        tabBar.tintColor = .black
        viewControllers = [homeNav, searchNav, addPostNav, likeNav, userProfileNav]
        
        // modify tab bar icon insests 
        
        guard let items = tabBar.items else {
            return
        }
        
        for item in items {
            item.imageInsets = UIEdgeInsets(top: 4, left: 0, bottom: -4, right: 0)
        }
        
    }
    
    func templateNavBarController(selectedImage:UIImage, unselectedImage: UIImage, rootViewController: UIViewController = UIViewController()) -> UINavigationController {
        let vc = rootViewController
        let nav =  UINavigationController(rootViewController: vc)
        nav.tabBarItem.selectedImage = selectedImage
        nav.tabBarItem.image = unselectedImage
        
        return nav
    }
}
