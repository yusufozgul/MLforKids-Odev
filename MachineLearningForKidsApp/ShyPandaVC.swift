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
    
private let captureSession = AVCaptureSession()
private lazy var previewLayer = AVCaptureVideoPreviewLayer(session: self.captureSession)
private let videoDataOutput = AVCaptureVideoDataOutput()

override func viewDidLoad() {
    super.viewDidLoad()
    self.addCameraInput()
    self.showCameraFeed()
    self.getCameraFrames()
    self.captureSession.startRunning()
    self.player.view.frame = self.view.bounds

    self.videoView.addSubview(self.player.view)
    
    player.playbackLoops = true
    player.fillMode = .resizeAspect
    
    
    videoView.alpha = 0
}

override func viewDidLayoutSubviews() {
    super.viewDidLayoutSubviews()
    self.previewLayer.frame = self.view.frame
}

    private func captureOutput(_ output: AVCaptureOutput, didOutput sampleBuffer: CMSampleBuffer, rom connection: AVCaptureConnection) {
    
    guard let frame = CMSampleBufferGetImageBuffer(sampleBuffer) else {
        debugPrint("unable to get image from sample buffer")
        return
    }
    self.detectFace(in: frame)
}

private func addCameraInput() {
    guard let device = AVCaptureDevice.DiscoverySession(
        deviceTypes: [.builtInWideAngleCamera, .builtInDualCamera, .builtInTrueDepthCamera],
        mediaType: .video,
        position: .front).devices.first else {
            fatalError("No back camera device found, please make sure to run SimpleLaneDetection in an iOS device and not a simulator")
    }
    let cameraInput = try! AVCaptureDeviceInput(device: device)
    self.captureSession.addInput(cameraInput)
}

private func showCameraFeed() {
    self.previewLayer.videoGravity = .resizeAspectFill
//    self.view.layer.addSublayer(self.previewLayer)
    self.previewLayer.frame = self.view.frame
}

private func getCameraFrames() {
    self.videoDataOutput.videoSettings = [(kCVPixelBufferPixelFormatTypeKey as NSString) : NSNumber(value: kCVPixelFormatType_32BGRA)] as [String : Any]
    self.videoDataOutput.alwaysDiscardsLateVideoFrames = true
    self.videoDataOutput.setSampleBufferDelegate(self, queue: DispatchQueue(label: "camera_frame_processing_queue"))
    self.captureSession.addOutput(self.videoDataOutput)
    guard let connection = self.videoDataOutput.connection(with: AVMediaType.video),
        connection.isVideoOrientationSupported else { return }
    connection.videoOrientation = .portrait
}

private func detectFace(in image: CVPixelBuffer) {
    let faceDetectionRequest = VNDetectFaceLandmarksRequest(completionHandler: { (request: VNRequest, error: Error?) in
        DispatchQueue.main.async {
            if let results = request.results as? [VNFaceObservation], results.count > 0 {
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
                self.player.playFromCurrentTime()
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
    })
    let imageRequestHandler = VNImageRequestHandler(cvPixelBuffer: image, orientation: .leftMirrored, options: [:])
    try? imageRequestHandler.perform([faceDetectionRequest])
}
}
