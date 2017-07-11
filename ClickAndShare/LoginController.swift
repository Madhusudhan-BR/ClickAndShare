//
//  LoginController.swift
//  ClickAndShare
//
//  Created by Madhusudhan B.R on 7/11/17.
//  Copyright © 2017 Madhusudhan. All rights reserved.
//

import UIKit
import FirebaseAuth

class LoginController : UIViewController {
    
    let toSignupButton : UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Don't have an account yet? Sign up!", for: .normal)
        button.addTarget(self, action: #selector(handleToSignup), for: .touchUpInside)
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.white
        view.addSubview(toSignupButton)
        self.navigationController?.isNavigationBarHidden = true
        toSignupButton.anchor(top: nil, left: view.leftAnchor, bottom: view.bottomAnchor, right: view.rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 50)
    }
    
    func handleToSignup() {
        let signupVC = ViewController()
        navigationController?.pushViewController(signupVC, animated: true)
    }
    
    
    
}

