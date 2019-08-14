//
//  CameraVC.swift
//  Vision
//
//  Created by Krystyna Kruchkovska on 8/13/19.
//  Copyright © 2019 Mac. All rights reserved.
//

import UIKit
import AVFoundation
import CoreML
import Vision

class CameraVC: UIViewController {
    
    var captureSession: AVCaptureSession!
    var cameraOutput: AVCapturePhotoOutput!
    var previewLayer: AVCaptureVideoPreviewLayer!
    var photoData: Data!
    
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
        setupCaptureSettion()
        setupTapGesture()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        previewLayer.frame = cameraView.bounds
        
    }
    
    private func setupTapGesture() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(didTapCameraView))
        tap.numberOfTapsRequired = 1
        cameraView.addGestureRecognizer(tap)
    }
    
    @objc  func didTapCameraView() {
        let settings = AVCapturePhotoSettings()
        settings.previewPhotoFormat = settings.embeddedThumbnailPhotoFormat
        cameraOutput.capturePhoto(with: settings, delegate: self)
    }
    
    private func setupCaptureSettion() {
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
                captureSession.addOutput(cameraOutput)
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
    
    func resultsMethods(request: VNRequest, error: Error?) {
        guard let results = request.results as? [VNClassificationObservation] else {
            return
        }
        
        for classification in results {
            if classification.confidence < 0.5 {
                self.identificationLbl.text = "I'am not sure what it is. Please try again"
                self.confidanceLbl.text = ""
                break
            } else {
                self.identificationLbl.text = classification.identifier
                self.confidanceLbl.text = "CONFIDENCE: \(Int(classification.confidence * 100))%"
                break
            }
        }
    }
    
}

extension CameraVC: AVCapturePhotoCaptureDelegate {
    
    func photoOutput(_ output: AVCapturePhotoOutput, didFinishProcessingPhoto photo: AVCapturePhoto, error: Error?) {
        
        if let error = error {
            debugPrint(error)
        } else {
           photoData = photo.fileDataRepresentation()
            
            do {
                let model = try VNCoreMLModel(for: SqueezeNet().model)
                let request = VNCoreMLRequest(model: model) { [weak self] (request, error) in
                    self?.resultsMethods(request: request, error: error)
                }
                let handler = VNImageRequestHandler(data: photoData)
                try handler.perform([request])
                
            } catch {
                debugPrint(error)
            }
            
            let image = UIImage(data: photoData)
            self.captureImageView.image = image
        }
    }
}
