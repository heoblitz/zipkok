//
//  StringToDateExtension.swift
//  zipkok
//
//  Created by won heo on 2021/01/24.
//

import Foundation

extension String {
    var stringToDate: Date? {
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "ko-KR")
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        
        return dateFormatter.date(from: self)
    }
}
