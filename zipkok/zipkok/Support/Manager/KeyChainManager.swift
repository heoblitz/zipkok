//
//  KeyChainManager.swift
//  zipkok
//
//  Created by won heo on 2021/01/20.
//

import Foundation
import SwiftKeychainWrapper

final class KeyChainManager {
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
    
    var fcmToken: String? {
        get {
            return KeychainWrapper.standard.string(forKey: "fcmToken")
        } set {
            guard let value = newValue else { return }
            KeychainWrapper.standard.set(value, forKey: "fcmToken")
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
    
    var userName: String? {
        get {
            return KeychainWrapper.standard.string(forKey: "userName")
        }
        set {
            guard let value = newValue else { return }
            KeychainWrapper.standard.set(value, forKey: "userName")
        }
    }
    
    var challengeIdx: Int? {
        get {
            return KeychainWrapper.standard.integer(forKey: "challengeIdx")
        } set {
            guard let value = newValue else { return }
            KeychainWrapper.standard.set(value, forKey: "challengeIdx")
        }
    }
}
