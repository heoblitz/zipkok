//
//  DateFormatExtension.swift
//  zipkok
//
//  Created by won heo on 2021/01/22.
//

import Foundation

extension Date {
    var challengeTimeFormat: String {
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "ko-KR")
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        
        return dateFormatter.string(from: self)
    }
    
    var challengeSelectTimeFormat: String {
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "ko-KR")
        dateFormatter.dateFormat = "M/dd HH:mm a"
        dateFormatter.amSymbol = "AM"
        dateFormatter.pmSymbol = "PM"
        
        return dateFormatter.string(from: self)
    }
}
