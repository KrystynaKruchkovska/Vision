//
//  CameraVC.swift
//  Vision
//
//  Created by Krystyna Kruchkovska on 8/13/19.
//  Copyright © 2019 Mac. All rights reserved.
//

import UIKit
import AVFoundation

class CameraVC: UIViewController {
    
    var captureSession: AVCaptureSession!
    var cameraOutput: AVCapturePhotoOutput!
    var previewLayer: AVCaptureVideoPreviewLayer!
    
    @IBOutlet weak var cameraView: UIView!
    @IBOutlet weak var identificationLbl: UILabel!
    @IBOutlet weak var confidanceLbl: UILabel!
    @IBOutlet weak var roundedLblView: RoundedShadowView!
    @IBOutlet weak var captureImageView: RoundedShadowImageView!
    @IBOutlet weak var flashButton: RoundedShadowButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        captureSession = AVCaptureSession()
        captureSession.sessionPreset = .hd1920x1080
        
        let backCamera = AVCaptureDevice.default(for: .video)
        
        do {
            let input = try AVCaptureDeviceInput(device: backCamera!)
            if captureSession.canAddInput(input) {
                captureSession.addInput(input)
            }
            
            cameraOutput = AVCapturePhotoOutput()
            
            if captureSession.canAddOutput(cameraOutput) {
                captureSession.canAddOutput(cameraOutput)
            }
            
            previewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
            previewLayer.videoGravity = .resizeAspect
            previewLayer.connection?.videoOrientation = .portrait
            
            cameraView.layer.addSublayer(previewLayer)
            captureSession.startRunning()
        } catch {
            debugPrint(error)
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        previewLayer.frame = cameraView.bounds
    }

}

