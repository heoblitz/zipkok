//
//  SelectChallengeViewModel.swift
//  zipkok
//
//  Created by won heo on 2021/01/20.
//

import Foundation

final class SelectChallengeViewModel {
    var challenges: Observable<[Challenge]> = Observable([])
    
    init() {
        bindChallengs()
    }
    
    func bindChallengs() {
        challenges.value = [
            Challenge(dayNumber: 1, difficulty: 1),
            Challenge(dayNumber: 2, difficulty: 2),
            Challenge(dayNumber: 3, difficulty: 2),
            Challenge(dayNumber: 5, difficulty: 3),
            Challenge(dayNumber: 7, difficulty: 4)
        ]
    }
}
