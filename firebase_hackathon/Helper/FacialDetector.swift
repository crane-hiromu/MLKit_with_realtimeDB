//
//  FacialDetector.swift
//  firebase_hackathon
//
//  Created by HiromuTsuruta on 2019/09/14.
//  Copyright © 2019年 HIromu. All rights reserved.
//

import AVFoundation
import FirebaseMLVision

final class FacialDetector {

    static let shared = FacialDetector()
    private init() {}
    
    private var counter = 0
    private lazy var vision = Vision.vision()
    
    private let detectorOptions: VisionFaceDetectorOptions = {
        let options = VisionFaceDetectorOptions()
        options.performanceMode = .accurate
        options.landmarkMode = .all
        options.contourMode = .none
        options.classificationMode = .all
        options.isTrackingEnabled = true
        return options
    }()
}

extension FacialDetector {
    
    func detectFaces(buffer: CMSampleBuffer,
                     orientation: UIDeviceOrientation,
                     position: AVCaptureDevice.Position) -> [VisionFace]? {
        
        let metadata = VisionImageMetadata()
        metadata.orientation = imageOrientation(orientation: orientation, position: position)
        
        let visionImage = VisionImage(buffer: buffer)
        visionImage.metadata = metadata
        
        let faceDetector = vision.faceDetector(options: detectorOptions)
        
        guard let faces = try? faceDetector.results(in: visionImage), !faces.isEmpty else {
            debugPrint("Failed to detect faces")
            return nil
        }
        return faces
    }
    
    /// fixme (検知の制度を)
    private func imageOrientation(orientation: UIDeviceOrientation,
                                  position: AVCaptureDevice.Position) -> VisionDetectorImageOrientation {
        
        switch orientation {
        case .portrait:
            return position == .front ? .leftTop : .rightTop
        case .landscapeLeft:
            return position == .front ? .bottomLeft : .topLeft
        case .portraitUpsideDown:
            return position == .front ? .rightBottom : .leftBottom
        case .landscapeRight:
            return position == .front ? .topRight : .bottomRight
        case .faceDown, .faceUp, .unknown:
            return .leftTop
        }
    }
    
    func analysis(from faces: [VisionFace]) -> [String: Any] {
        var params = [String: Int]()
        
        for face in faces {
            counter += 1
            params["counter"] = counter
            if let timestamp = Int(DateFormatter().timestamp) {
                params["timestamp"] = timestamp
                print("timestamp: \(timestamp)")
            }
            
//            let frame = face.frame
            
//            if face.hasHeadEulerAngleY {
//                let rotY = face.headEulerAngleY
//                print("rotY: \(rotY)")
//            }
//            if face.hasHeadEulerAngleZ {
//                let rotZ = face.headEulerAngleZ
//                print("rotZ: \(rotZ)")
//            }

//            if let leftEye = face.landmark(ofType: .leftEye) {
//                let leftEyePosition = leftEye.position
//                print("leftEyePosition: \(leftEyePosition)")
//            }
//
//            if let leftEyeContour = face.contour(ofType: .leftEye) {
//                let leftEyePoints = leftEyeContour.points
//                print("leftEyePoints: \(leftEyePoints)")
//            }
//            if let upperLipBottomContour = face.contour(ofType: .upperLipBottom) {
//                let upperLipBottomPoints = upperLipBottomContour.points
//                print("upperLipBottomPoints: \(upperLipBottomPoints)")
//            }
            
            if face.hasSmilingProbability {
                let smileProb = face.smilingProbability * 100
                params["smileProb"] = Int(smileProb)
                debugPrint("smileProb: \(smileProb)")
            }
            if face.hasLeftEyeOpenProbability {
                let leftEyeOpenProb = face.leftEyeOpenProbability * 100
                params["leftEyeOpenProb"] = Int(leftEyeOpenProb)
                debugPrint("leftEyeOpenProb: \(leftEyeOpenProb)")
            }
            if face.hasRightEyeOpenProbability {
                let rightEyeOpenProb = face.rightEyeOpenProbability * 100
                params["rightEyeOpenProb"] = Int(rightEyeOpenProb)
                debugPrint("rightEyeOpenProb: \(rightEyeOpenProb)")
            }
            if face.hasTrackingID {
                let trackingId = face.trackingID
                params["trackingId"] = trackingId
                debugPrint("trackingId: \(trackingId)")
            }
        }
        return params
    }
}

extension DateFormatter {
    
    var timestamp: String {
        let timeInterval = NSDate().timeIntervalSince1970
        let myTimeInterval = TimeInterval(timeInterval)
        let time = NSDate(timeIntervalSince1970: TimeInterval(myTimeInterval))
        dateFormat = "yyyyMMddHHmmss"
        return self.string(from: time as Date)
    }
}

