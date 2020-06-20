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

    private lazy var monitorImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.backgroundColor = .white
        imageView.cornerRadius = 25
        imageView.borderColor = .gray
        imageView.borderWidth = 0.5
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    private lazy var monitorView: MonitorMainView = {
        let mainView: MonitorMainView = .instantiate()
        mainView.endButton.rx.tap.subscribe(onNext: { [weak self] in
            guard let self = self else { return }
            CaptureVideoManager.shared.stopRecording()
            debugPrint("----todo call api", FaceDirectionManager.shared.counters)
            self.dismiss(animated: true)
        }).disposed(by: rx.disposeBag)
        
        return mainView
    }()
    
    private let beforeOrientation: UIDeviceOrientation
    private lazy var viewFrame: CGRect = {
        /// fixme: 今回は時間がないので縦判定しかしない
        switch beforeOrientation {
        case .landscapeLeft, .landscapeRight:
            return CGRect(origin: monitorView.selfView.frame.origin, size: CGSize(
                width: monitorView.selfView.bounds.height,
                height: monitorView.selfView.bounds.width
            ))
        default:
            return monitorView.selfView.bounds
        }
    }()
    
    // MARK: initializer
    
    init(orientation: UIDeviceOrientation) {
        self.beforeOrientation = orientation
        super.init(nibName: nil, bundle: nil)
    }
    
    required convenience init?(coder: NSCoder) {
        self.init(orientation: .portrait)
    }
    
    // MARK: Override
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        initialView()
        requestPermission()
    }
    
    /// 画面回転した際にlayerのframeをそうだが厄介なので、この画面では回転させない
    /// その際、前の画面の向きを見て画面を生成する（beforeOrientation / viewFrame）
    override var shouldAutorotate: Bool {
        get {
            return false
        }
    }

    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        get {
            return .landscapeRight
        }
    }
}

extension MonitorViewController: CaptureVideoManagerDelegate {
    
    func captureOutput(didOutput buffer: CMSampleBuffer) {
        detectFaces(from: buffer)
    }
}

private extension MonitorViewController {
    
    func initialView() {
        view.equalToParentConstraint(for: monitorView)
        
        /// set your video
        let videoLayer = CaptureVideoManager.shared.videoLayer
        videoLayer.frame = viewFrame
        videoLayer.videoGravity = .resizeAspectFill
        monitorView.selfView.layer.addSublayer(videoLayer)
        
        play()
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
//        debugPrint("----- detectFaces ----")
        
        let result = FacialDetector.shared.detectFaces(
            buffer: buffer,
            orientation: UIDevice.current.orientation,
            position: AVCaptureDevice.Position.front
        )
        
        guard let faces = result else {
//            debugPrint("----- error detectFaces ----")
            return
        }
        
        let params = FacialDetector.shared.analysis(from: faces)
        guard !params.isEmpty else {
//            debugPrint("----- error params is empty ----")
            return
        }
        
        updateIcon(by: params)
    }
    
    func updateIcon(by params: [String: Any]) {
        let result = params.first { $0.key == "headEulerAngleY" }?.value as? Int ?? 0
        
        DispatchQueue.main.async {
            self.monitorImageView.image = 0 < result ? #imageLiteral(resourceName: "right") : #imageLiteral(resourceName: "left")
        }
    }
    
    
    func play() {
        /// 今回は決め打ちの動画
        
        // Bundle Resourcesからsample.mp4を読み込んで再生
        let path = Bundle.main.path(forResource: "woman", ofType: "mov")!
        let player = AVPlayer(url: URL(fileURLWithPath: path))
        player.play()
        // AVPlayer用のLayerを生成
        let playerLayer = AVPlayerLayer(player: player)
        playerLayer.frame = monitorView.rightView.bounds
        playerLayer.videoGravity = .resizeAspectFill
        playerLayer.zPosition = -1 // ボタン等よりも後ろに表示
        monitorView.rightView.layer.insertSublayer(playerLayer, at: 0)
        
        
        // Bundle Resourcesからsample.mp4を読み込んで再生
         let path2 = Bundle.main.path(forResource: "woman-2", ofType: "mov")!
         let player2 = AVPlayer(url: URL(fileURLWithPath: path2))
         player2.play()
         // AVPlayer用のLayerを生成
         let playerLayer2 = AVPlayerLayer(player: player2)
         playerLayer2.frame = monitorView.leftView.bounds
         playerLayer2.videoGravity = .resizeAspectFill
         playerLayer2.zPosition = -1 // ボタン等よりも後ろに表示
         monitorView.leftView.layer.insertSublayer(playerLayer2, at: 0)
         
         
    }
}
