//
//  LoginController.swift
//  ClickAndShare
//
//  Created by Madhusudhan B.R on 7/11/17.
//  Copyright © 2017 Madhusudhan. All rights reserved.
//

import UIKit
import FirebaseAuth

let blueColor = UIColor(red: 45/255, green: 213/255, blue: 255/255, alpha: 1)

class LoginController : UIViewController {
    
    
    
    let logoView : UIView = {
        let view = UIView()
        view.backgroundColor = blueColor
        let imageView = UIImageView()
        imageView.image = UIImage(named : "Asset3")
        imageView.contentMode = .scaleToFill
        view.addSubview(imageView)
        imageView.anchor(top: nil, left: nil, bottom: nil, right: nil, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 200, height: 50)
        imageView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        imageView.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        
        return view
    }()
    
    
    let emailTextField : UITextField = {
        let tf = UITextField()
        tf.translatesAutoresizingMaskIntoConstraints = false
        tf.placeholder = "Email"
        tf.backgroundColor = UIColor(white: 0, alpha: 0.03)
        tf.borderStyle = .roundedRect
        tf.addTarget(self, action: #selector(handleInputEdidting), for: .editingChanged)
        return tf
    }()
    
    let passwordTextField : UITextField = {
        let tf = UITextField()
        tf.translatesAutoresizingMaskIntoConstraints = false
        tf.placeholder = "Password"
        tf.backgroundColor = UIColor(white: 0, alpha: 0.03)
        tf.addTarget(self, action: #selector(handleInputEdidting), for: .editingChanged)
        tf.borderStyle = .roundedRect
        tf.isSecureTextEntry = true
        return tf
    }()
    
    let loginButton : UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Login", for: .normal)
        button.backgroundColor = blueColor //UIColor(red: 149/255, green: 204/255, blue: 244/255, alpha: 1)
        button.alpha = 0.4
        button.layer.cornerRadius = 5
        button.layer.masksToBounds = true
        button.setTitleColor(.white, for: .normal)
        button.addTarget(self, action: #selector(handleLoginButton), for: .touchUpInside)
        button.isEnabled = false
        return button
    }()
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }
    
    func handleLoginButton(){
        
        guard  let email = emailTextField.text?.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines), email.characters.count > 0  ,  let password = passwordTextField.text , password.characters.count > 0 else {
            return
        }
        
        view.endEditing(true)
        Auth.auth().signIn(withEmail: email , password: password) { (user, error) in
            if let error = error {
                print(error)
                appdelegate.infoView(message: error.localizedDescription, color: redColor)
                return 
            }
            print("Madhu: Succeess login ")
            appdelegate.infoView(message: "Logged In", color: greenColor)
            guard let mainTabBarController = UIApplication.shared.keyWindow?.rootViewController as? MainTabBarController else {
                return
            }
            mainTabBarController.initialSetup()
            self.dismiss(animated: true, completion: nil)
        }
        
}

    
    func handleInputEdidting() {
        let isFormValid = (emailTextField.text?.characters.count)!>0 && (passwordTextField.text?.characters.count)! > 0
        
        if isFormValid{
            loginButton.isEnabled = true
            loginButton.backgroundColor = blueColor//UIColor.rgb(red: 17, green: 154, blue: 237)
            loginButton.alpha = 1
        }else {
            loginButton.isEnabled = false
            loginButton.backgroundColor = blueColor //UIColor(red: 149/255, green: 204/255, blue: 244/255, alpha: 1)
            loginButton.alpha = 0.4
        }
    }
    
    let toSignupButton : UIButton = {
        let button = UIButton(type: .system)
        
        let attributedString = NSMutableAttributedString(string: "Don't have an account yet? ", attributes: [NSFontAttributeName : UIFont.systemFont(ofSize: 14) , NSForegroundColorAttributeName : UIColor.lightGray])
        attributedString.append(NSAttributedString(string: "Sign Up", attributes: [NSFontAttributeName : UIFont.boldSystemFont(ofSize: 14) , NSForegroundColorAttributeName : UIColor.rgb(red: 17, green: 154, blue: 237)]))
        
        button.setAttributedTitle(attributedString, for: .normal)
        button.addTarget(self, action: #selector(handleToSignup), for: .touchUpInside)
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.white
        view.addSubview(toSignupButton)
        self.navigationController?.isNavigationBarHidden = true
        toSignupButton.anchor(top: nil, left: view.leftAnchor, bottom: view.bottomAnchor, right: view.rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 50)
        
        anchorLogoView()
        anchorInputViews()
    }
    
    func anchorLogoView(){
        view.addSubview(logoView)
        logoView.anchor(top: view.topAnchor, left: view.leftAnchor, bottom: nil, right: view.rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 200)
    }
    
    func anchorInputViews(){
        let stackView = UIStackView(arrangedSubviews: [emailTextField,  passwordTextField, loginButton])
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.distribution = .fillEqually
        stackView.axis = .vertical
        stackView.spacing = 10
        
        view.addSubview(stackView)
        NSLayoutConstraint.activate([stackView.topAnchor.constraint(equalTo: logoView.bottomAnchor, constant: 20),
                                     stackView.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 40),
                                     stackView.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -40),
                                     stackView.heightAnchor.constraint(equalToConstant: 150)
            ])
        
        
    }

    
    
    func handleToSignup() {
        let signupVC = ViewController()
        navigationController?.pushViewController(signupVC, animated: true)
    }
    
    
    
}

