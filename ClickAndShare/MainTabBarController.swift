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
        
        logoAnimation()
        
        tabBar.tintColor = .white
        tabBar.barTintColor = UIColor(red: 45/255, green: 213/255, blue: 255/255, alpha: 1)
        tabBar.isTranslucent = false
        
        
        
        if Auth.auth().currentUser?.uid == nil {
           
            
            let loginVC = LoginController()
            let navController = NavController(rootViewController: loginVC)
            DispatchQueue.main.async {
                self.present(navController, animated: true, completion: nil)
            }
        }
        
        self.delegate = self
        
        initialSetup()
    }
    
    func logoAnimation(){
        let layer = UIView()
        layer.frame = self.view.frame
        layer.backgroundColor = blueColor
        view.addSubview(layer)
        
        let icon = UIImageView()
        icon.image = UIImage(named: "clickandshareicon120.png")
        icon.frame.size.width = 100
        icon.frame.size.height = 100
        icon.layer.cornerRadius = 50
        icon.clipsToBounds = true
        icon.center = view.center
        view.addSubview(icon)
        
        UIView.animate(withDuration: 0.5, delay: 1, options: .curveLinear, animations: { 
            icon.transform = CGAffineTransform( scaleX: 0.9, y: 0.9)
        }) { (_) in
            UIView.animate(withDuration: 0.5, animations: { 
                icon.transform = CGAffineTransform( scaleX: 20 , y: 20)
                
                UIView.animate(withDuration: 0.1, delay: 0.3, options: .curveLinear, animations: { 
                    icon.alpha = 0
                    layer.alpha = 0
                }, completion: nil)
                
            })
        }
    }
    
    func tabBarController(_ tabBarController: UITabBarController, shouldSelect viewController: UIViewController) -> Bool {
        
        if  let index = viewControllers?.index(of: viewController) {
            if index == 2 {
                
                
                let alertController = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
                
                alertController.addAction(UIAlertAction(title: "Share Picture", style: .default, handler: { (_) in
                    
                    
                    let photoSelectorVC = PhotoSelectorController(collectionViewLayout: UICollectionViewFlowLayout())
                    let navController = UINavigationController(rootViewController: photoSelectorVC)
                    self.present(navController, animated: true, completion: nil)
                    
                }))
                alertController.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
                alertController.addAction(UIAlertAction(title: "Share a Thought", style: .default, handler: { (_) in
                    let shareVC = ThoughtShareVC()
                    let navController = UINavigationController(rootViewController: shareVC)
                    self.present(navController, animated: true, completion: nil)
                }))
                alertController.popoverPresentationController?.sourceView = self.view
                alertController.popoverPresentationController?.permittedArrowDirections = []
                alertController.popoverPresentationController?.sourceRect = CGRect(x: self.view.bounds.midX , y: self.view.bounds.midY , width: 0  , height: 0)
                
                
                present(alertController, animated: true, completion: nil)
                
                
                
                
                return false
            }
//            if index == 3 {
//                saveFeedack()
//                return false
//            }
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
        let userProfileNav = NavController(rootViewController: userProfileController)
        userProfileNav.tabBarItem.selectedImage = #imageLiteral(resourceName: "profile_selected").imageColor(color: UIColor.white).withRenderingMode(.alwaysOriginal)
        userProfileNav.tabBarItem.image = #imageLiteral(resourceName: "profile_unselected").imageColor(color: UIColor(red: 240, green: 240, blue: 240, alpha: 1)).withRenderingMode(.alwaysOriginal)
        
        let homeNav = templateNavBarController(selectedImage: #imageLiteral(resourceName: "home_selected"), unselectedImage: #imageLiteral(resourceName: "home_unselected"),rootViewController: HomeController(collectionViewLayout: UICollectionViewFlowLayout()))
        let searchNav = templateNavBarController(selectedImage: #imageLiteral(resourceName: "search_selected"), unselectedImage: #imageLiteral(resourceName: "search_unselected"),rootViewController: SearchController(collectionViewLayout: UICollectionViewFlowLayout()))
        let addPostNav = templateNavBarController(selectedImage: #imageLiteral(resourceName: "ic_add_box_white"), unselectedImage: #imageLiteral(resourceName: "ic_add_box_white"))
        let likeNav = templateNavBarController(selectedImage: #imageLiteral(resourceName: "like_selected"), unselectedImage: #imageLiteral(resourceName: "like_unselected"))
        
        
        viewControllers = [homeNav, searchNav, addPostNav, userProfileNav]
        
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
        let nav =  NavController(rootViewController: vc)
        nav.tabBarItem.selectedImage = selectedImage.imageColor(color: UIColor.white).withRenderingMode(.alwaysOriginal)
        nav.tabBarItem.image = unselectedImage.imageColor(color: UIColor(red: 240, green: 240, blue: 240, alpha: 1)).withRenderingMode(.alwaysOriginal)

        
        return nav
    }
}
extension UIImage {
    func imageColor(color: UIColor) -> UIImage {
        UIGraphicsBeginImageContextWithOptions(self.size, false, self.scale)
        let context = UIGraphicsGetCurrentContext() as! CGContext
        context.translateBy(x: 0, y: self.size.height)
        context.scaleBy(x: 1.0, y: -1.0)
        
        let rect = CGRect(x: 0, y: 0, width: self.size.width, height: self.size.height)
        context.clip(to: rect, mask: self.cgImage!)
        
        color.setFill()
        context.fill(rect)
        
        let newImage = UIGraphicsGetImageFromCurrentImageContext() as! UIImage
        UIGraphicsEndImageContext()
        return newImage
    }
}
