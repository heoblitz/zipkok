//
//  SettingViewModel.swift
//  zipkok
//
//  Created by won heo on 2021/01/20.
//

import Foundation

final class SettingViewModel {
    private let keyChainManager = KeyChainManager()
        
    var userInfo: Observable<UserInfoResult> = Observable(UserInfoResult(userName: "", addressName: "", pushStatus: ""))
    
    func requestUserInfo() {
        guard let jwt = keyChainManager.jwtToken, let userId = keyChainManager.userId else {
            return
        }
        
        ZipkokApi.shared.userInfo(jwt: jwt, id: userId) { response in
            guard let result = response.result else { return }
            self.userInfo.value = result
        }
    }
}
