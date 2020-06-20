//
//  FaceDirectionManager.swift
//  firebase_hackathon
//
//  Created by h.crane on 2020/06/20.
//  Copyright © 2020 Hiromu. All rights reserved.
//

import Foundation

// MARK: - Manager

final class FaceDirectionManager {
    
    typealias Counters = (left: Int, right: Int)
    
    static let shared = FaceDirectionManager()
    private init() {}
    
    enum Direction {
        case right, left
    }
    
    var counters: Counters = (left: 0, right: 0)
    
    func add(direction: Direction) {
        switch direction {
        case .right: counters.right += 1
        case .left: counters.left += 1
        }
    }
    
    func reset() {
        counters = (left: Int, right: Int)()
    }
}
