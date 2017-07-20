//
//  CameraController.swift
//  ClickAndShare
//
//  Created by Madhusudhan B.R on 7/20/17.
//  Copyright © 2017 Madhusudhan. All rights reserved.
//

import UIKit
import AVFoundation

class CameraController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        setupCameraSession()
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
        
        let output = AVCapturePhotoOutput()
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
