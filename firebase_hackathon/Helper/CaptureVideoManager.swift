//
//  CaptureVideoManager.swift
//  firebase_hackathon
//
//  Created by Hiromu Tsuruta on 2019/09/19.
//  Copyright © 2019 HIromu. All rights reserved.
//

import AVKit

// MARK: - Delegate

protocol CaptureVideoManagerDelegate: class {
    func captureOutput(didOutput buffer: CMSampleBuffer)
}


// MARK: - Result

enum CaptureVideoResult {
    case success(_ manager: CaptureVideoManager)
    case failure
}


// MARK: - Manager

final class CaptureVideoManager: NSObject {
    
    static let shared = CaptureVideoManager()
    private override init() {}
    
    weak var delegate: CaptureVideoManagerDelegate?
    lazy var videoLayer: AVCaptureVideoPreviewLayer = {
        return AVCaptureVideoPreviewLayer(session: captureSession)
    }()
    private let captureSession = AVCaptureSession()
    private let videoDevice = AVCaptureDevice.default(.builtInWideAngleCamera, for: .video, position: .front)

    private lazy var videoOutput: AVCaptureVideoDataOutput = {
        let output = AVCaptureVideoDataOutput()
        let queue = DispatchQueue(label: "videoOutput", attributes: .concurrent)
        output.setSampleBufferDelegate(self, queue: queue)
        output.alwaysDiscardsLateVideoFrames = true
        return output
    }()
}


// MARK: - Internal

extension CaptureVideoManager {
    
    func requestPermission(completion: @escaping (CaptureVideoResult) -> Void) {
        AVCaptureDevice.requestAccess(for: .video) { [weak self] granted in
            guard let self = self else { return }
            completion((granted ? .success(self) : .failure))
        }
    }
    
    func initialSession() {
        guard let vDevice = videoDevice, let vInput = try? AVCaptureDeviceInput(device: vDevice) else {
            debugPrint("error: non videoDevice")
            return
        }
        
        guard captureSession.inputs.isEmpty else { return }
        captureSession.addInput(vInput)
        captureSession.addOutput(videoOutput)
    }
    
    func startRecording() {
        captureSession.startRunning()
    }
    
    func stopRecording() {
        captureSession.stopRunning()
    }
}


// MARK: - AVCaptureVideoDataOutputSampleBufferDelegate

extension CaptureVideoManager: AVCaptureVideoDataOutputSampleBufferDelegate {
    
    func captureOutput(_ output: AVCaptureOutput,
                       didOutput sampleBuffer: CMSampleBuffer,
                       from connection: AVCaptureConnection) {
        
        delegate?.captureOutput(didOutput: sampleBuffer)
    }
}
