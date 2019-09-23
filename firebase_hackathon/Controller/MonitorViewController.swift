//
//  MonitorViewController.swift
//  firebase_hackathon
//
//  Created by HiromuTsuruta on 2019/09/14.
//  Copyright © 2019年 HIromu. All rights reserved.
//

import UIKit
import AVKit
import AVFoundation
import Firebase
import RxSwift
import Nuke

final class MonitorViewController: UIViewController {
    
    private lazy var controlButton: UIButton = {
        let btn = UIButton()
        btn.setTitle("✖️", for: UIControl().state)
        btn.backgroundColor = .lightGray
        btn.cornerRadius = 10
        btn.borderColor = .gray
        btn.borderWidth = 0.5
        btn.rx.tap.asDriver().drive(onNext: { [weak self] in
            guard let self = self else { return }
            CaptureVideoManager.shared.stopRecording()
            self.dismiss(animated: true)
        }).disposed(by: rx.disposeBag)
        return btn
    }()
    
    private lazy var monitorImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.backgroundColor = .white
        imageView.cornerRadius = 10
        imageView.borderColor = .gray
        imageView.borderWidth = 0.5
        imageView.image = #imageLiteral(resourceName: "normal")
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    private var isLaugh: Bool = false
    
    // MARK: Override
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        /// 実装の都合上、今回は毎回DBをリセットする
//        ConnectionManager.shared.remove(by: .faces)
        
        initialView()
        requestPermission()
    }
}

extension MonitorViewController: CaptureVideoManagerDelegate {
    
    func captureOutput(didOutput buffer: CMSampleBuffer) {
        detectFaces(from: buffer)
    }
}

private extension MonitorViewController {
    
    func initialView() {
        let videoLayer = CaptureVideoManager.shared.videoLayer
        videoLayer.frame = self.view.bounds
        videoLayer.videoGravity = .resizeAspectFill
        view.layer.addSublayer(videoLayer)
        
        view.equalToConstraint(for: controlButton, with: [
            controlButton.topAnchor.constraint(equalTo: view.topAnchor, constant: 44),
            controlButton.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -20),
            controlButton.widthAnchor.constraint(equalToConstant: 60),
            controlButton.heightAnchor.constraint(equalToConstant: 60)
        ])
        
        view.equalToConstraint(for: monitorImageView, with: [
            monitorImageView.topAnchor.constraint(equalTo: view.topAnchor, constant: 44),
            monitorImageView.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 20),
            monitorImageView.widthAnchor.constraint(equalToConstant: 60),
            monitorImageView.heightAnchor.constraint(equalToConstant: 60)
        ])
    }
    
    func requestPermission() {
        CaptureVideoManager.shared.requestPermission { result in
            switch result {
            case .success(let manager):
                manager.delegate = self
                manager.initialSession()
                manager.startRecording()
                
            case .failure:
                // do some error handling
                break
            }
        }
    }
    
    func detectFaces(from buffer: CMSampleBuffer) {
        debugPrint("----- detectFaces ----")
        
        let result = FacialDetector.shared.detectFaces(
            buffer: buffer,
            orientation: UIDevice.current.orientation,
            position: AVCaptureDevice.Position.back
        )
        
        guard let faces = result else {
            debugPrint("----- error detectFaces ----")
            return
        }
        
        let params = FacialDetector.shared.analysis(from: faces)
        guard !params.isEmpty else {
            debugPrint("----- error params is empty ----")
            return
        }
        
        updateIcon(by: params)
//        ConnectionManager.shared.write(by: .faces, params: params)
    }
    
    func updateIcon(by params: [String: Any]) {
        params.forEach {
            if $0.key == "smileProb" {
                isLaugh = 70 < $0.value as! Int
                
                DispatchQueue.main.async {
                    self.monitorImageView.image = self.isLaugh ? #imageLiteral(resourceName: "laugh") : #imageLiteral(resourceName: "normal")
                }
            } else if !isLaugh, $0.key == "leftEyeOpenProb" {
                let isSleeping: Bool = ($0.value as! Int) < 10
                DispatchQueue.main.async {
                    self.monitorImageView.image = isSleeping ? #imageLiteral(resourceName: "sleep") : #imageLiteral(resourceName: "normal")
                }
            }
        }
    }
}
