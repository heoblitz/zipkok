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
    private let kakaoLoginURLString = "/login/kakao"
    private let registerURLString = "/users"
    
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
    
    func userInfo(jwt jwtToken: String, id userId: Int, completionHandler: @escaping (UserInfoResponse) -> ()) {
        let headers: HTTPHeaders = ["X-ACCESS-TOKEN" : jwtToken]

        let request = AF.request(baseURLString + registerURLString + "/\(userId)", method: .get, encoding: Alamofire.JSONEncoding.default, headers: headers)
        
        request.responseDecodable(of: UserInfoResponse.self) { response in
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
    
    func patchUserInfo(jwt jwtToken: String, id userId: Int, location locationInfo: LocationInfo, isPushStatusEnable: Bool = false, completionHandler: @escaping (PatchUserInfoResponse) -> ()) {
        let headers: HTTPHeaders = ["X-ACCESS-TOKEN" : jwtToken]
        let bodys: Parameters = [
            "pushStatus" : isPushStatusEnable == true ? "Y" : "N",
            "latitude" : locationInfo.latitude,
            "longitude" : locationInfo.longitude,
            "parcelAddressing" : locationInfo.parcelName,
            "streetAddressing" : locationInfo.name
        ]
        
        let request = AF.request(baseURLString + registerURLString + "/\(userId)", method: .patch, parameters: bodys, encoding: Alamofire.JSONEncoding.default, headers: headers)
        
        request.responseDecodable(of: PatchUserInfoResponse.self) { response in
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

// MARK:- kakaoLogin
struct KakaoLoginResponse: Codable {
    let isSuccess: Bool
    let code: Int
    let message: String
    let result: KakaologinResult?
}

struct KakaologinResult: Codable {
    let userId: Int
    let jwt: String
}

// MARK:- register
struct RegisterResponse: Codable {
    let isSuccess: Bool
    let code: Int
    let message: String
    let result: RegisterResult?
}

struct RegisterResult: Codable {
    let userId: Int
    let jwt: String
}


// MARK:- userInfo
struct UserInfoResponse: Codable {
    let isSuccess: Bool
    let code: Int
    let message: String
    let result: UserInfoResult?
}

struct UserInfoResult: Codable {
    let userName: String
    let addressName: String
    let pushStatus: String
    
    var isPushStatusEnable: Bool {
        return pushStatus == "Y" ? true : false
    }
    
    func changeAddressName(by address: String) -> UserInfoResult {
        return UserInfoResult(userName: self.userName, addressName: address, pushStatus: self.pushStatus)
    }
}


// MARK:- patchUserInfo
struct PatchUserInfoResponse: Codable {
    let isSuccess: Bool
    let code: Int
    let message: String
    let result: PatchUserInfo?
}

struct PatchUserInfo: Codable {
    let userIdx: Int
}
