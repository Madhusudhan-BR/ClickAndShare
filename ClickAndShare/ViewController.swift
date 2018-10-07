//
//  ViewController.swift
//  ClickAndShare
//
//  Created by Madhusudhan B.R on 7/9/17.
//  Copyright © 2017 Madhusudhan. All rights reserved.
//

import UIKit
import Firebase

class ViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    let toSigninButton : UIButton = {
        let button = UIButton(type: .system)
        
        let attributedString = NSMutableAttributedString(string: "Have an account already? ", attributes: [NSFontAttributeName : UIFont.systemFont(ofSize: 14) , NSForegroundColorAttributeName : UIColor.lightGray])
        attributedString.append(NSAttributedString(string: "Sign In", attributes: [NSFontAttributeName : UIFont.boldSystemFont(ofSize: 14) , NSForegroundColorAttributeName : blueColor]))
        
        button.setAttributedTitle(attributedString, for: .normal)
        button.addTarget(self, action: #selector(handleToSignin), for: .touchUpInside)
        return button
    }()
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }
    
    let eulaButton : UIButton = {
        let button = UIButton(type: .system)
        
        let attributedString = NSMutableAttributedString(string: "Click here to View EULA. By SigningUp,you agree to our ", attributes: [NSFontAttributeName : UIFont.systemFont(ofSize: 12) , NSForegroundColorAttributeName : UIColor.lightGray])
        attributedString.append(NSAttributedString(string: "EULA", attributes: [NSFontAttributeName : UIFont.boldSystemFont(ofSize: 14) , NSForegroundColorAttributeName : blueColor]))
        
        button.setAttributedTitle(attributedString, for: .normal)
        button.addTarget(self, action: #selector(handleEULA), for: .touchUpInside)
        return button
    }()
    
    let EULATextField: UITextView = {
        let tf = UITextView()
        tf.isEditable = false
        if let path = Bundle.main.path(forResource: "eula", ofType: "txt") {
            do {
                let data = try String(contentsOfFile: path, encoding: .utf8)
                let myStrings = data.components(separatedBy: .newlines)
                tf.text = myStrings.joined(separator: " \n ")
            } catch {
                print(error)
            }
        }
        tf.backgroundColor = UIColor.white
        tf.textAlignment = .center
        tf.translatesAutoresizingMaskIntoConstraints = false
        
        return tf
    }()
    
    func handleEULA() {
        setupSlideInView()
    }
    
    func handleToSignin() {
        navigationController?.popViewController(animated: true)
    }
    
    let addPhotoButton: UIButton = {
        let button = UIButton(type : .system)
        button.setImage(#imageLiteral(resourceName: "plus_photo"), for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(handleAddphotoButton), for: .touchUpInside)
        return button
    }()
    
    func handleAddphotoButton(){
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.allowsEditing = true
        present(imagePicker, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        
        if let editedImage = info["UIImagePickerControllerEditedImage"] as? UIImage {
            addPhotoButton.setImage(editedImage.withRenderingMode(.alwaysOriginal), for: .normal)
        } else if let originalImage = info["UIImagePickerControllerOriginalImage"] as? UIImage {
            addPhotoButton.setImage(originalImage.withRenderingMode(.alwaysOriginal), for: .normal)
        }
        
        addPhotoButton.layer.cornerRadius = addPhotoButton.frame.width/2
        addPhotoButton.layer.masksToBounds = true
        addPhotoButton.layer.borderColor = UIColor.black.cgColor
        addPhotoButton.layer.borderWidth = 3.0
        
        dismiss(animated: true, completion: nil)
    }
    
    let emailTextField : UITextField = {
        let tf = UITextField()
        tf.translatesAutoresizingMaskIntoConstraints = false
        tf.placeholder = "Email"
        tf.backgroundColor = UIColor(white: 0, alpha: 0.03)
        tf.borderStyle = .roundedRect
        tf.addTarget(self, action: #selector(handleInputEdidting), for: .editingChanged)
        return tf
    }()
    
    func handleInputEdidting() {
        let isFormValid = (emailTextField.text?.characters.count)!>0 && (usernameTextField.text?.characters.count)!>0 && (passwordTextField.text?.characters.count)! > 0
        
        if isFormValid{
            signupButton.isEnabled = true
            signupButton.backgroundColor = blueColor//UIColor.rgb(red: 17, green: 154, blue: 237)
            signupButton.alpha = 1
        }else {
            signupButton.isEnabled = false
            signupButton.backgroundColor = blueColor//UIColor(red: 149/255, green: 204/255, blue: 244/255, alpha: 1)
            signupButton.alpha = 0.4
        }
    }
    
    let usernameTextField : UITextField = {
        let tf = UITextField()
        tf.translatesAutoresizingMaskIntoConstraints = false
        tf.placeholder = "Username"
        tf.backgroundColor = UIColor(white: 0, alpha: 0.03)
        tf.addTarget(self, action: #selector(handleInputEdidting), for: .editingChanged)
        tf.borderStyle = .roundedRect
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
    
    let signupButton : UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Sign up", for: .normal)
        button.alpha = 0.4
        button.backgroundColor = blueColor //UIColor(red: 149/255, green: 204/255, blue: 244/255, alpha: 1)
        button.layer.cornerRadius = 5
        button.layer.masksToBounds = true
        button.setTitleColor(.white, for: .normal)
        button.addTarget(self, action: #selector(handleSignupButton), for: .touchUpInside)
        button.isEnabled = false
        return button
    }()
    
    func handleSignupButton(){
        
        guard  let email = emailTextField.text?.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines), email.characters.count > 0  , let username = usernameTextField.text ,username.characters.count > 0 ,  let password = passwordTextField.text , password.characters.count > 0 else {
            return
        }
        view.endEditing(true)
        Auth.auth().createUser(withEmail: email, password: password) { (user, error) in
            if error != nil {
                print(error.debugDescription)
                appdelegate.infoView(message: error.debugDescription, color: redColor)
                return
            }
            
            guard let uid = user?.uid else {
                return
            }
            
            guard let image = self.addPhotoButton.imageView?.image else {
                return
            }
            
            guard let uploadData = UIImageJPEGRepresentation(image, 0.2) else {
                return
            }
            
            let imageName = NSUUID().uuidString
           
            
            Storage.storage().reference().child("profile_images").child(imageName).putData(uploadData, metadata: nil, completion: { (metadata, error) in
                if let error = error {
                    print(error.localizedDescription)
                    return
                }
                print("Madhu: ProfileImage uploaded to firebase storage")
                guard let profileImageURL = metadata?.downloadURL()?.absoluteString else {
                    return
                }
                
                
                let userValues = ["username" : username, "email" : email, "profileImageURL" : profileImageURL ]
                let values = [uid : userValues]
                
                Database.database().reference().child("users").updateChildValues(values, withCompletionBlock: { (error, ref) in
                    if let error = error {
                        print(error.localizedDescription)
                        return
                    }
                    print("Madhu: Saved user to DB")
                })
                
            })
            print("MADHU : Successfully created user \(username)")
            appdelegate.infoView(message: "Successfully registered", color: greenColor)
            guard let mainTabBarController = UIApplication.shared.keyWindow?.rootViewController as? MainTabBarController else {
                return
            }
            mainTabBarController.initialSetup()
            self.dismiss(animated: true, completion: nil)
        }
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.addSubview(addPhotoButton)
        view.backgroundColor = UIColor.white
        addPhotoButton.widthAnchor.constraint(equalToConstant: 140).isActive = true
        addPhotoButton.heightAnchor.constraint(equalToConstant: 140).isActive = true
        addPhotoButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        addPhotoButton.topAnchor.constraint(equalTo: view.topAnchor, constant: 40).isActive = true
        
        
        setupInput()
        view.addSubview(toSigninButton)
        toSigninButton.anchor(top: nil, left: view.leftAnchor, bottom: view.bottomAnchor, right: view.rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 50)
        
        view.addSubview(eulaButton)
        eulaButton.anchor(top: nil, left: view.leftAnchor, bottom: toSigninButton.topAnchor, right: view.rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 8, paddingRight: 0, width: 0, height: 50)
    }
    
    fileprivate func  setupInput() {
        
        
        let stackView = UIStackView(arrangedSubviews: [emailTextField, usernameTextField, passwordTextField, signupButton])
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.distribution = .fillEqually
        stackView.axis = .vertical
        stackView.spacing = 10
        
        view.addSubview(stackView)
        NSLayoutConstraint.activate([stackView.topAnchor.constraint(equalTo: addPhotoButton.bottomAnchor, constant: 20),
                                     stackView.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 40),
                                     stackView.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -40),
                                     stackView.heightAnchor.constraint(equalToConstant: 200)
            ])
    }
    
    
    
    //MARK: ALL EULA
    
    var blackView = UIView()
    let verificationView : UIView = {
        //let layout = UICollectionViewFlowLayout()
        let view = UIView()
        view.backgroundColor =  UIColor.white //UIColor(red: 244/255, green: 167/255, blue: 35/255, alpha: 1)
        return view
    }()
    
    func setupSlideInView() {
        self.blackView = UIView()
        blackView.backgroundColor = UIColor(white: 0, alpha: 0.5)
        if let window = UIApplication.shared.keyWindow {
            window.addSubview(blackView)
            window.addSubview(verificationView)
            let height: CGFloat = 500
            let y = window.frame.height - height
            verificationView.frame = CGRect(x: 0, y: window.frame.height, width: window.frame.width, height: height)
            blackView.frame = view.frame
            blackView.alpha = 0
            blackView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleBlackViewDismiss)))
            
            
            self.verificationView.addSubview(EULATextField)
            EULATextField.leftAnchor.constraint(equalTo: verificationView.leftAnchor, constant: 8).isActive = true
            EULATextField.topAnchor.constraint(equalTo: verificationView.topAnchor, constant: 8).isActive = true
            EULATextField.rightAnchor.constraint(equalTo: verificationView.rightAnchor, constant: -8).isActive = true
            EULATextField.heightAnchor.constraint(equalToConstant: 500).isActive = true
            
            
            UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
                self.blackView.alpha = 1
                self.verificationView.frame = CGRect(x: 0, y: y, width: self.verificationView.frame.width, height: self.verificationView.frame.height)
                
                
            }, completion: nil)
            
            
        }
        
    }
    
    func handleBlackViewDismiss() {
        UIView.animate(withDuration: 0.5) {
            
            if let window = UIApplication.shared.keyWindow {
                self.verificationView.frame = CGRect(x: 0, y: window.frame.height, width: self.verificationView.frame.width, height: self.verificationView.frame.height)
            }
            
            self.blackView.alpha = 0
        }
    }
 

}




