//
//  Challenge.swift
//  zipkok
//
//  Created by won heo on 2021/01/20.
//

import Foundation

struct Challenge {
    let dayNumber: Int
    let difficulty: Int
    
    var koreanDayFormat: String {
        return "\(dayNumber)일"
    }
}
