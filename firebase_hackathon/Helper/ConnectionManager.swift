//
//  ConnectionManager.swift
//  firebase_hackathon
//
//  Created by HiromuTsuruta on 2019/09/14.
//  Copyright © 2019年 HIromu. All rights reserved.
//

import Firebase

final class ConnectionManager {
    
    enum Keys: String, CaseIterable {
        case faces
    }
    
    static let shared = ConnectionManager()
    private init() {}
    
    private let reference = Database.database().reference()
    
    func write(by key: Keys, params: [String: Any]) {
        let userReference = reference.child(key.rawValue)
        userReference.childByAutoId().setValue(params)
    }
    
    func remove(by key: Keys) {
        let userReference = reference.child(key.rawValue)
        userReference.removeValue()
    }
    
    func connect(by key: Keys) {
        let userReference = reference.child(key.rawValue)
        userReference.observe(.childAdded) { snap in
            // do something
        }
    }

    func disconnect(by key: Keys) {
        let userReference = reference.child(key.rawValue)
        userReference.removeAllObservers()
    }
}
