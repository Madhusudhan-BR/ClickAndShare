//
//  PhotoSelectorController.swift
//  ClickAndShare
//
//  Created by Madhusudhan B.R on 7/12/17.
//  Copyright © 2017 Madhusudhan. All rights reserved.
//

import UIKit

class PhotoSelectorController : UICollectionViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .yellow
        
        setupNavBar()
        
    }
    
    fileprivate func setupNavBar(){
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(handleCancel))
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Next", style: .plain, target: self, action: #selector(handleNext))
        self.navigationController?.navigationBar.tintColor = .black
    }
    
    override var prefersStatusBarHidden: Bool {
        return true
     }
    
    func handleCancel() {
        dismiss(animated: true , completion: nil)
    }
    
    func handleNext() {
        print("Next! ")
    }
}

