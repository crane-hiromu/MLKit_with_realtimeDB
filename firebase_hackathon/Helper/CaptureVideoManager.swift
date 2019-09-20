//
//  CaptureVideoManager.swift
//  firebase_hackathon
//
//  Created by Hiromu Tsuruta on 2019/09/19.
//  Copyright © 2019 HIromu. All rights reserved.
//

import AVKit

final class CaptureVideoManager {
    
    static let shared = CaptureVideoManager()
    private init() {}
    
    private let captureSession = AVCaptureSession()
    private var videoOutput = AVCaptureVideoDataOutput()
    private let videoDevice = AVCaptureDevice.default(for: AVMediaType.video)
    
    func requestPermission(completion: @escaping (CaptureVideoResult) -> Void) {
        AVCaptureDevice.requestAccess(for: .video) { [weak self] granted in
            guard let self = self else { return }
            
            if granted {
                self.initialSession()
                completion(.success(output: self.videoOutput))
            } else {
                completion(.failure)
            }
        }
    }
    
    func initialSession() {
        guard let vDevice = videoDevice, let vInput = try? AVCaptureDeviceInput(device: vDevice) else {
            debugPrint("error: non videoDevice")
            return
        }
        
//        vDevice.activeVideoMinFrameDuration = CMTimeMake(value: 1, timescale: Int32(0))
//        vDevice.unlockForConfiguration()
        
        captureSession.addInput(vInput)
        
        let videoQueue = DispatchQueue(label: "videoOutput", attributes: .concurrent)
//        videoOutput.setSampleBufferDelegate(self, queue: queue)
        videoOutput.alwaysDiscardsLateVideoFrames = true
        
        guard captureSession.canAddOutput(videoOutput) else { return }
        captureSession.addOutput(videoOutput)
    }
    
    func startRecording() {
        captureSession.startRunning()
    }
    
    func stopRecording() {
        captureSession.stopRunning()
    }
}

enum CaptureVideoResult {
    case success(output: AVCaptureVideoDataOutput)
    case failure
}
