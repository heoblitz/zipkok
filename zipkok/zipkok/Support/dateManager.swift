//
//  dateManager.swift
//  zipkok
//
//  Created by won heo on 2021/01/14.
//

import Foundation

class DateManager {
    private let userDefalt = UserDefaults.init(suiteName: "circle")
    
    var startDate: Date? {
        set {
            userDefalt?.set(newValue, forKey: "startDate")
            userDefalt?.synchronize()
        }
        get {
            return userDefalt?.object(forKey: "startDate") as? Date
        }
    }
    
    var endDate: Date? {
        set {
            userDefalt?.set(newValue, forKey: "endDate")
            userDefalt?.synchronize()
        }
        get {
            return userDefalt?.object(forKey: "endDate") as? Date
        }
    }
}
