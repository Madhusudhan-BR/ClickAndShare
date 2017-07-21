//
//  CameraController.swift
//  ClickAndShare
//
//  Created by Madhusudhan B.R on 7/20/17.
//  Copyright © 2017 Madhusudhan. All rights reserved.
//

import UIKit
import AVFoundation

class CameraController: UIViewController, AVCapturePhotoCaptureDelegate {
    
    let output = AVCapturePhotoOutput()
    
    let captureButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(#imageLiteral(resourceName: "capture_photo").withRenderingMode(.alwaysOriginal), for: .normal)
        button.addTarget(self, action: #selector(handleCaptureButton), for: .touchUpInside)
        return button
    }()
    
    func handleCaptureButton(){
        print("handling capture button ")
        let settings = AVCapturePhotoSettings()
        guard let format = settings.availablePreviewPhotoPixelFormatTypes.first else {
            return
        }
        settings.previewPhotoFormat = [kCVPixelBufferPixelFormatTypeKey as String: format]
        output.capturePhoto(with: settings, delegate: self)
    }
    
    func capture(_ captureOutput: AVCapturePhotoOutput, didFinishProcessingPhotoSampleBuffer photoSampleBuffer: CMSampleBuffer?, previewPhotoSampleBuffer: CMSampleBuffer?, resolvedSettings: AVCaptureResolvedPhotoSettings, bracketSettings: AVCaptureBracketedStillImageSettings?, error: Error?) {
        print("finsihed processing")
        
        guard  let imageData =  AVCapturePhotoOutput.jpegPhotoDataRepresentation(forJPEGSampleBuffer: photoSampleBuffer!, previewPhotoSampleBuffer: previewPhotoSampleBuffer!) else {
            return
        }
        
        let image = UIImage(data: imageData)
        
        let previewContainer = PreviewPhotoContainerView()
        view.addSubview(previewContainer)
        previewContainer.anchor(top: view.topAnchor, left: view.leftAnchor, bottom: view.bottomAnchor, right: view.rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 0)
        previewContainer.imageView.image = image
    }
    
    let dismissButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(#imageLiteral(resourceName: "right_arrow_shadow").withRenderingMode(.alwaysOriginal), for: .normal)
        button.addTarget(self, action: #selector(handleDismissButton), for: .touchUpInside)
        return button
    }()
    
    
    
    func handleDismissButton(){
        dismiss(animated: true, completion: nil)
    }

    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupCameraSession()
        
        view.addSubview(captureButton)
        captureButton.anchor(top: nil, left: nil, bottom: view.bottomAnchor, right: nil, paddingTop: 0, paddingLeft: 0, paddingBottom: -24, paddingRight: 0, width: 80, height: 80)
        captureButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        
        view.addSubview(dismissButton)
        dismissButton.anchor(top: view.topAnchor, left: nil, bottom: nil, right: view.rightAnchor, paddingTop: 12, paddingLeft: 0, paddingBottom: 0, paddingRight: 12, width: 60, height: 60)
    }
    
    override var prefersStatusBarHidden: Bool {
        return true 
    }
    
    fileprivate func setupCameraSession(){
        let captureSession = AVCaptureSession()
        // step 1 : setup inputs  
        
        let captureDevice = AVCaptureDevice.defaultDevice(withMediaType: AVMediaTypeVideo)
        do {
            let input = try AVCaptureDeviceInput(device: captureDevice)
            if captureSession.canAddInput(input){
                captureSession.addInput(input)
            }
        } catch let err {
            print("could't initialize camera", err)
        }
        //step 2 : setup outputs 
        
        
        if captureSession.canAddOutput(output) {
            captureSession.addOutput(output)
        }
        
        //step 3: setup output preview 
        guard let preview  = AVCaptureVideoPreviewLayer(session: captureSession) else { return }
        preview.frame = view.frame
        view.layer.addSublayer(preview)
        
        //One more step 
        captureSession.startRunning()
    }
}
