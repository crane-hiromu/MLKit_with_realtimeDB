//
//  ViewController.swift
//  firebase_hackathon
//
//  Created by HiromuTsuruta on 2019/09/13.
//  Copyright © 2019年 HIromu. All rights reserved.
//

import UIKit
import AVKit
import AVFoundation
import Firebase
import RxSwift

final class ViewController: UIViewController {
    

    @IBOutlet private weak var startButton: UIButton! {
        didSet {
            startButton.rx.tap.asDriver().drive(onNext: { [weak self] in
                guard let self = self else { return }
                let vc = MonitorViewController(orientation: UIDevice.current.orientation)
                vc.modalPresentationStyle = .overFullScreen
                self.present(vc, animated: true)
            }).disposed(by: rx.disposeBag)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
    }
}
