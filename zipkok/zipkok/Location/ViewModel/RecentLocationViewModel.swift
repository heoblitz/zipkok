//
//  RecentLocationManager.swift
//  zipkok
//
//  Created by won heo on 2021/01/23.
//

import Foundation

class RecentLocationViewModel {
    var locations: Observable<[RecentLocation]> = Observable([])
    
    func requestRecentLocations(jwt jwtToken: String) {
        ZipkokApi.shared.recentLocation(jwt: jwtToken) { recentLocationResponse in
            guard let locations = recentLocationResponse.result else {
                print("---> result can't loaded")
                return
            }
            
            self.locations.value = locations
        }
    }
}
