//
//  ShareController.swift
//  ClickAndShare
//
//  Created by Madhusudhan B.R on 7/15/17.
//  Copyright © 2017 Madhusudhan. All rights reserved.
//

import UIKit

class ShareController : UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.white
        navigationController?.navigationBar.tintColor = UIColor.black 
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Share", style: .done, target: self, action: #selector(handleShare))
    }
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    func handleShare() {
        print("handling share")
    }
    
}
