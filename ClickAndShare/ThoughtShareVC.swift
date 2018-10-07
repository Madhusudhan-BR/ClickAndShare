//
//  ThoughtShareVC.swift
//  ClickAndShare
//
//  Created by Madhusudhan B.R on 8/1/17.
//  Copyright © 2017 Madhusudhan. All rights reserved.
//

import UIKit
import Firebase

class ThoughtShareVC: UIViewController{
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.white
        navigationController?.navigationBar.tintColor = UIColor.black
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Share", style: .done, target: self, action: #selector(handleShare))
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Cancel", style: .done, target: self, action: #selector(handleCancel))
        setupContainerView()
    }
    
    func handleCancel(){
        dismiss(animated: true, completion: nil)
    }
    
    func handleShare() {
        guard  let caption = captionTextView.text, caption != "" else {
            saveFeedack()
            return
        }
        self.navigationItem.rightBarButtonItem?.isEnabled = false
        
        //guard let imageToUpload = selectedImage else { return }
        
        //let imageUUID = NSUUID().uuidString
        
        //guard let imageData = UIImageJPEGRepresentation(imageToUpload, 0.5) else { return }
        
//        Storage.storage().reference().child("Posts").child(imageUUID).putData(imageData, metadata: nil) { (metadata, error) in
//            
//            if let error = error {
//                self.navigationItem.rightBarButtonItem?.isEnabled = true
//                print(error.localizedDescription)
//                return
//            }
//            
//            guard let imageURL = metadata?.downloadURL()?.absoluteString else { return }
//            
//            print("The storage link is ", imageURL)
//            
//            self.uploadToDatabase(imageUrl : imageURL)
//        }
        uploadToDatabase()
    }
    
    func uploadToDatabase(){
        
        guard  let caption = captionTextView.text, caption != "" else {
            saveFeedack()
            return
        }
        
        guard let uid = Auth.auth().currentUser?.uid else { return }
        
        let values = ["imageUrl": "none", "caption": caption, "imageWidth": 0, "imageHeight": 0, "creationDate": Date().timeIntervalSince1970] as [String: Any]
        
        Database.database().reference().child("posts").child(uid).childByAutoId().updateChildValues(values) { (error, reference) in
            if let error = error {
                self.navigationItem.rightBarButtonItem?.isEnabled = true
                print(error.localizedDescription)
                return
            }
            
            let notification = NotificationCenter.default.post(name: ShareController.notificationName, object: nil)
            
            self.dismiss(animated: true, completion: nil)
            
            print("Post data has been uploaded to firebase")
            
        }
        
    }

    func saveFeedack() {
        let label = UILabel()
        label.text = "Please enter a thought to share"
        label.textAlignment = .center
        label.textColor = UIColor.white
        label.numberOfLines = 0
        label.backgroundColor = UIColor(white: 0, alpha: 0.2)
        view.addSubview(label)
        label.frame = CGRect(x: 0, y: 0, width: 200, height: 80)
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
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(false)
    }
    
    
    let captionTextView : UITextField = {
        let textfield  = UITextField()
        textfield.placeholder = "Enter a thought here"
        textfield.layer.cornerRadius = 6
        textfield.backgroundColor = UIColor.rgb(red: 240, green: 240, blue: 240)
        textfield.placeholder = "Enter a caption here"
        return textfield
    }()
    
    fileprivate func setupContainerView(){
        let containerView = UIView()
        containerView.backgroundColor = UIColor.white
        view.addSubview(containerView)
        containerView.anchor(top: topLayoutGuide.bottomAnchor, left: view.leftAnchor, bottom: nil, right: view.rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height:  100)
        
        
        containerView.addSubview(captionTextView)
        captionTextView.anchor(top: containerView.topAnchor, left: containerView.leftAnchor, bottom: containerView.bottomAnchor, right: containerView.rightAnchor, paddingTop: 8, paddingLeft: 8, paddingBottom: -8, paddingRight: 8, width: 0, height: 0)
        
        
    }
}
