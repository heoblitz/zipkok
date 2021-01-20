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

    private let baseURLString = "http://15.164.161.25"
    private let autoLoginURLString = "/login/jwt"
    private let registerURLString = "/users"
    private let kakaoLoginURLString = "/login/kakao"
    
    private init() {}

    func kakaoLogin(token accessToken: String, completionHandler: @escaping (KakaoLoginResponse) -> ()) {
        let bodys: Parameters = ["accessToken" : accessToken]

        let request = AF.request(baseURLString + kakaoLoginURLString, method: .post, parameters: bodys, encoding: Alamofire.JSONEncoding.default)
        
        request.responseDecodable(of: KakaoLoginResponse.self) { response in
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
    
    func register(location locationInfo: LocationInfo, user userInfo: ResponseUserInformation, completionHandler: @escaping (RegisterResponse) -> ()) {
        let bodys: Parameters = [
            "userName" : userInfo.kakaoAccount.profile.nickname,
            "userEmail" : userInfo.kakaoAccount.email ?? "test@test.com",
            "snsId" : userInfo.id,
            "latitude" : locationInfo.latitude,
            "longitude" : locationInfo.longitude,
            "parcelAddressing" : locationInfo.parcelName,
            "streetAddressing" : locationInfo.name,
            "loginType" : "KAKAO"
        ]

        let request = AF.request(baseURLString + registerURLString, method: .post, parameters: bodys, encoding: Alamofire.JSONEncoding.default)
        
        request.responseDecodable(of: RegisterResponse.self) { response in
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
    /*  "userName" : "skdnvklskd",
        "userEmail" : "snkvlsdmkv",
        "snsId": 1111001,
        "latitude":13.2223,
        "longitude":2343.343,
        "parcelAddressing":"경기도 ",
        "streetAddressing":"경기도 성남시 분당구",
       "loginType":"KAKAO"
    */
}

// MARK:- kakaoLogin
struct KakaoLoginResponse: Codable {
    let isSuccess: Bool
    let code: Int
    let message: String
    // let result: kakaologinResult
}

struct KakaologinResult: Codable {
    let userId: Int
    let jwt: String
}


// MARK:- register
struct RegisterResponse: Codable {
    let jwt: String?
    let isSuccess: Bool
    let code: Int
    let message: String
}

