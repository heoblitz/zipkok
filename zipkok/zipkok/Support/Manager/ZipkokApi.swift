//
//  ZipkokApi.swift
//  zipkok
//
//  Created by won heo on 2021/01/16.
//

import Foundation
import Alamofire

class ZipkokApi {
    static let shared = ZipkokApi()

    private let baseURLString = "http://homealoneapi.ga"
    private let autoLoginURLString = "/login/jwt"
    private let registerURLString = "/users"
    private let kakaoLoginURLString = "/login/kakao"
    
    private init() {}
    
    func register() {
        
    }
    
    func kakaoLogin(token accessToken: String, completionHandler: @escaping (kakaoLoginResponse) -> ()) {
        let bodys: Parameters = ["accessToken" : accessToken]
        
        let request = AF.request(baseURLString + kakaoLoginURLString, method: .post, parameters: bodys)
        
        request.responseDecodable(of: kakaoLoginResponse.self) { response in
            if let error = response.error {
                print(error)
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

struct kakaoLoginResponse: Codable {
    let isSuccess: Bool
    let code: Int
    let message: String
    let result: kakaologinResult
}

struct kakaologinResult: Codable {
    let userId: Int
    let jwt: String
}
