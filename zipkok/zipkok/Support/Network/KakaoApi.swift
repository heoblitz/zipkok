//
//  KakaoApi.swift
//  zipkok
//
//  Created by won heo on 2021/01/20.
//

import Foundation
import Alamofire

class KakaoApi {
    static let shared = KakaoApi()
    
    private let baseURLString: String = "https://kapi.kakao.com/v2"
    private let userInfoURLString: String = "/user/me"
    
    private init() {}
    
    func getUserInformation(token accessToken: String, completionHandler: @escaping (ResponseUserInformation) -> ()) {
        let headers: HTTPHeaders = ["Authorization" : "Bearer " + accessToken]
        let request = AF.request(baseURLString + userInfoURLString, method: .get, headers: headers)
        
        request.responseDecodable(of: ResponseUserInformation.self) { response in
            if let error = response.error {
                print(error)
                print(response)
                return
            }
            
            guard let value = response.value else {
                print("data is nil")
                return
            }
            
            print(value)
            completionHandler(value)
        }
    }
}

// MARK:- getUserInformation
struct ResponseUserInformation: Codable {
    let id: Int
    let kakaoAccount: KakaoAccount
    
    enum CodingKeys: String, CodingKey {
        case id
        case kakaoAccount = "kakao_account"
    }
}

struct KakaoAccount: Codable {
    let profile: KakaoAccountProfile
    let email: String?
}

struct KakaoAccountProfile: Codable {
    let nickname: String
}
