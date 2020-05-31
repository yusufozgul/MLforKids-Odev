//
//  ShyPandaVC.swift
//  MachineLearningForKidsApp
//
//  Created by Yusuf Özgül on 5.05.2020.
//  Copyright © 2020 Hızlı ve Buglı. All rights reserved.
//

import UIKit
import AVFoundation
import Vision

class ShyPandaVC: UIViewController, AVCaptureVideoDataOutputSampleBufferDelegate {
    
    @IBOutlet weak var lookView: UIView!
    @IBOutlet weak var lookSlider: UISlider!
    
    @IBOutlet weak var dontLookView: UIView!
    @IBOutlet weak var dontlookSlider: UISlider!
    
    @IBOutlet weak var videoView: UIView!
    var player: Player = Player()
    var vcisAlive: Bool = true
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.player.view.frame = self.view.bounds
        
        self.videoView.addSubview(self.player.view)
        
        player.playbackLoops = true
        player.fillMode = .resizeAspect
        
        
        videoView.alpha = 0
        setupCamera()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        player.removeFromParent()
        player.stop()
        vcisAlive = false
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
                        if results.count > 0 {
                            print("did detect \(results.count) face(s)")
                            self.player.pause()
                            if self.lookSlider.value != 1 &&  self.dontlookSlider.value != 1{
                                self.lookSlider.value += 0.01
                                
                                if self.lookSlider.value >= 1.0 {
                                    self.lookSlider.value = 1
                                }
                            } else {
                                self.lookView.alpha = 0.6
                                self.lookView.isHidden = true
                            }
                            
                        } else {
                            print("did not detect any face")
                            if self.vcisAlive {
                                self.player.playFromCurrentTime()
                            }
                            
                            if self.lookSlider.value == 1.0 {
                                
                                if self.dontlookSlider.value != 1 {
                                    self.dontlookSlider.value += 0.01
                                    
                                    if self.dontlookSlider.value >= 1.0 {
                                        self.dontlookSlider.value = 1
                                        self.dontLookView.isHidden = true
                                    }
                                } else {
                                    self.dontLookView.alpha = 0.6
                                    print("Tamam")
                                    if self.videoView.alpha == 0 {
                                        self.player.url = Bundle.main.url(forResource: "shyPandaVideo", withExtension: "mp4")
                                        self.player.playFromBeginning()
                                    }
                                    
                                    self.dontLookView.isHidden = true
                                    self.videoView.alpha = 1
                                }
                            }
                        }
                    }
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
    
}
