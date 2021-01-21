//
//  KeyChainManager.swift
//  zipkok
//
//  Created by won heo on 2021/01/20.
//

import Foundation
import SwiftKeychainWrapper

class KeyChainManager {
    var accessToken: String? {
        get {
            return KeychainWrapper.standard.string(forKey: "accessToken")
        } set {
            guard let value = newValue else { return }
            KeychainWrapper.standard.set(value, forKey: "accessToken")
        }
    }
    
    var jwtToken: String? {
        get {
            return KeychainWrapper.standard.string(forKey: "jwtToken")
        } set {
            guard let value = newValue else { return }
            KeychainWrapper.standard.set(value, forKey: "jwtToken")
        }
    }
    
    var userId: Int? {
        get {
            return KeychainWrapper.standard.integer(forKey: "userId")
        } set {
            guard let value = newValue else { return }
            KeychainWrapper.standard.set(value, forKey: "userId")
        }
    }
}
