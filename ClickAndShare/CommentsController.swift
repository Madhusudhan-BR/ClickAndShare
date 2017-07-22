//
//  CommentsController.swift
//  ClickAndShare
//
//  Created by Madhusudhan B.R on 7/22/17.
//  Copyright © 2017 Madhusudhan. All rights reserved.
//

import UIKit

class CommentsController: UICollectionViewController  {
   
    
    let containerView: UIView = {
        let container = UIView()
        return container
    }()
    
    lazy var  submitButton: UIButton = {
        let button = UIButton(type : .system)
        button.setTitle("Submit", for: .normal)
        button.addTarget(self, action: #selector(handleSubmit), for: .touchUpInside)
        return button
    }()
    
    func handleSubmit() {
        print("submitting...........")
    }
    
    let inpuTextField: UITextField = {
        let tf = UITextField()
        tf.placeholder = "Enter a comment"
        return tf
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "Comments"
        collectionView?.backgroundColor = UIColor.white
        containerView.frame = CGRect(x: 0, y: 0, width: view.frame.width, height: 50)
        containerView.addSubview(inpuTextField)
        containerView.addSubview(submitButton)
        inpuTextField.anchor(top: containerView.topAnchor, left: containerView.leftAnchor, bottom: containerView.bottomAnchor, right: submitButton.leftAnchor, paddingTop: 0, paddingLeft: 12, paddingBottom: 0, paddingRight: 12, width: 0, height: 0)
        
        submitButton.anchor(top: containerView.topAnchor, left: nil, bottom: containerView.bottomAnchor, right: containerView.rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 12, width: 60, height: 0)
    }
    
    override var inputAccessoryView: UIView? {
        get {
            return containerView
        }
    }
    
    override var canBecomeFirstResponder: Bool {
        return true
    }
    
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        tabBarController?.tabBar.isHidden = false
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tabBarController?.tabBar.isHidden = true
    }
    
    
    
}
