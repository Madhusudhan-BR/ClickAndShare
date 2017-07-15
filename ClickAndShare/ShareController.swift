//
//  ShareController.swift
//  ClickAndShare
//
//  Created by Madhusudhan B.R on 7/15/17.
//  Copyright © 2017 Madhusudhan. All rights reserved.
//

import UIKit
import Firebase

class ShareController : UIViewController {
    
    
    var selectedImage : UIImage? {
        didSet{
            imageView.image = selectedImage
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.rgb(red: 240, green: 240, blue: 240)
        navigationController?.navigationBar.tintColor = UIColor.black
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Share", style: .done, target: self, action: #selector(handleShare))
        
        setupContainerView()
    }
    
    let imageView : UIImageView = {
         let iv = UIImageView()
        iv.contentMode = .scaleAspectFill
        iv.clipsToBounds = true
        return iv
    }()
    
    let captionTextView : UITextField = {
        let textfield  = UITextField()
        textfield.placeholder = "Enter a caption here"
        return textfield
    }()
    
    fileprivate func setupContainerView(){
        let containerView = UIView()
        containerView.backgroundColor = UIColor.white
        view.addSubview(containerView)
        containerView.anchor(top: topLayoutGuide.bottomAnchor, left: view.leftAnchor, bottom: nil, right: view.rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: view.frame.width + 100)
        
        containerView.addSubview(imageView)
        imageView.anchor(top: containerView.topAnchor, left: containerView.leftAnchor, bottom: nil, right: containerView.rightAnchor, paddingTop: 8, paddingLeft: 8, paddingBottom: 0, paddingRight: 8, width: 0, height: view.frame.width)
        
        containerView.addSubview(captionTextView)
        captionTextView.anchor(top: imageView.bottomAnchor, left: containerView.leftAnchor, bottom: containerView.bottomAnchor, right: containerView.rightAnchor, paddingTop: 8, paddingLeft: 8, paddingBottom: -8, paddingRight: 8, width: 0, height: 0)
        
        
    }
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    func handleShare() {
        guard let imageToUpload = selectedImage else { return }
        
        let imageUUID = NSUUID().uuidString
        
        guard let imageData = UIImageJPEGRepresentation(imageToUpload, 0.5) else { return }
        
        Storage.storage().reference().child("Posts").child(imageUUID).putData(imageData, metadata: nil) { (metadata, error) in
            
            if let error = error {
                print(error.localizedDescription)
                return
            }
            
            guard let imageURL = metadata?.downloadURL()?.absoluteString else { return }
            
            print("The storage link is ", imageURL)
            
        }
        
    }
    
}
