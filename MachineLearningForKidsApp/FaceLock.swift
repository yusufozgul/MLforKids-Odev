//
//  FaceLock.swift
//  MachineLearningForKidsApp
//
//  Created by Yusuf Özgül on 31.05.2020.
//  Copyright © 2020 Hızlı ve Buglı. All rights reserved.
//


import UIKit
import AVFoundation
import Vision

class FaceLock: UIViewController, AVCaptureVideoDataOutputSampleBufferDelegate {
    
    @IBOutlet weak var imageView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
    }
    
    fileprivate func setupCamera() {
        let captureSession = AVCaptureSession()
        captureSession.sessionPreset = .high
        
        guard let device = AVCaptureDevice.DiscoverySession(
            deviceTypes: [.builtInWideAngleCamera, .builtInDualCamera, .builtInTrueDepthCamera],
            mediaType: .video,
            position: .front).devices.first else {
                fatalError("No back camera device found, please make sure to run in an iOS device and not a simulator")
        }
        guard let input = try? AVCaptureDeviceInput(device: device) else { return }
        captureSession.addInput(input)
        
        captureSession.startRunning()
        
        let previewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
        view.layer.addSublayer(previewLayer)
        previewLayer.frame = view.frame
        previewLayer.isHidden = true
        
        let dataOutput = AVCaptureVideoDataOutput()
        dataOutput.setSampleBufferDelegate(self, queue: DispatchQueue(label: "videoQueue"))
        captureSession.addOutput(dataOutput)
    }
    func captureOutput(_ output: AVCaptureOutput, didOutput sampleBuffer: CMSampleBuffer, from connection: AVCaptureConnection) {
        
        guard let pixelBuffer: CVPixelBuffer = CMSampleBufferGetImageBuffer(sampleBuffer) else { return }
        
        let request = VNDetectFaceRectanglesRequest { (req, err) in
            
            if let err = err {
                print("Failed to detect faces:", err)
                return
            }
            
            DispatchQueue.main.async {
                if let results = req.results {
                    DispatchQueue.main.async {
                        if results.count == 1 {
                            UIView.transition(with: self.imageView,
                            duration: 0.75,
                            options: .transitionCrossDissolve,
                            animations: { self.imageView.image = UIImage(systemName: "lock.open.fill") },
                            completion: nil)
                        } else {
                            UIView.transition(with: self.imageView,
                            duration: 0.75,
                            options: .transitionCrossDissolve,
                            animations: { self.imageView.image = UIImage(systemName: "lock.fill") },
                            completion: nil)
                        }
                    }
                    print(results.count)
                }
            }
        }
        
        DispatchQueue.global(qos: .userInteractive).async {
            let handler = VNImageRequestHandler(cvPixelBuffer: pixelBuffer, options: [:])
            do {
                try handler.perform([request])
            } catch let reqErr {
                print("Failed to perform request:", reqErr)
            }
        }
        
    }
    
    @IBAction func tapScan(_ sender: Any) {
        self.setupCamera()
    }
}
