//
//  PreviewPhotoContainerView.swift
//  ClickAndShare
//
//  Created by Madhusudhan B.R on 7/21/17.
//  Copyright © 2017 Madhusudhan. All rights reserved.
//

import UIKit
import Photos

class PreviewPhotoContainerView : UIView {
    
    let imageView : UIImageView = {
        let iv = UIImageView()
        return iv
    }()
    
    lazy var cancelButton: UIButton = {
        let options = UIButton(type: .system)
        options.setImage(#imageLiteral(resourceName: "cancel_shadow").withRenderingMode(.alwaysOriginal), for: .normal)
        options.addTarget(self, action: #selector(handleCancel), for: .touchUpInside)
        return options
    }()
    
    func handleCancel() {
        self.removeFromSuperview()
    }
    
    lazy var saveButton: UIButton = {
        let options = UIButton(type: .system)
        options.setImage(#imageLiteral(resourceName: "save_shadow").withRenderingMode(.alwaysOriginal), for: .normal)
         options.addTarget(self, action: #selector(handleSave), for: .touchUpInside)
        return options
    }()
    
    func handleSave() {
       
        guard let previewImage = imageView.image else { return }
        let library = PHPhotoLibrary.shared()
        
        library.performChanges({ 
            PHAssetChangeRequest.creationRequestForAsset(from: previewImage)
        }) { (success, error) in
            if let error = error {
                print(error)
                return
            }
        }
        print("saved to library")
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(imageView)
        imageView.anchor(top: topAnchor, left: leftAnchor, bottom: bottomAnchor, right: rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 0)
        
        addSubview(cancelButton)
        cancelButton.anchor(top: topAnchor, left: leftAnchor, bottom: nil, right: nil, paddingTop: 12, paddingLeft: 12, paddingBottom: 0, paddingRight: 0, width: 60, height: 60)
        addSubview(saveButton)
        saveButton.anchor(top: nil, left: leftAnchor, bottom: bottomAnchor, right: nil, paddingTop: 0, paddingLeft: 12, paddingBottom: -24, paddingRight: 0, width: 60, height: 60)
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
