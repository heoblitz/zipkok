//
//  ClassNameExtension.swift
//  zipkok
//
//  Created by won heo on 2021/01/22.
//

import Foundation

public extension NSObject {
    static func storyboardName() -> String {
        return String(describing: self).replacingOccurrences(of: "ViewController", with: "")
    }
}
