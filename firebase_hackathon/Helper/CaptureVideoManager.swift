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
    private let videoQueue = DispatchQueue(label: "videoOutput", attributes: .concurrent)
    
    func requestPermission(completion: @escaping (Bool) -> Void) {
        AVCaptureDevice.requestAccess(for: .video) { [weak self] granted in
            guard let self = self else { return }
            
            if granted {
                self.initialSession()
            }
            completion(granted)
        }
    }
    
    func initialSession() {
        guard let vDevice = videoDevice, let vInput = try? AVCaptureDeviceInput(device: vDevice) else {
            print("error: non videoDevice")
            return
        }
        captureSession.addInput(vInput)
        
        let queue: DispatchQueue = DispatchQueue(label: "videoOutput", attributes: .concurrent)
//        videoOutput.setSampleBufferDelegate(self, queue: queue)
        videoOutput.alwaysDiscardsLateVideoFrames = true
        captureSession.addOutput(videoOutput)
    }
}
