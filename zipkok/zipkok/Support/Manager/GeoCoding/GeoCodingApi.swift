//
//  GeoCoding.swift
//  zipkok
//
//  Created by won heo on 2021/01/15.
//

import Foundation
import Alamofire

class GeoCodingApi {
    static let shared = GeoCodingApi()
    
    private let baseURLString = "https://dapi.kakao.com"
    private let reigoncode2CoordURLString = "/v2/local/search/address.json"
    private let coord2regioncodeURLString = "/v2/local/geo/coord2address.json"
    
    private init() {}
    
    func requestCoord(by regionName: String, completionHandler: @escaping (Double, Double) -> ()) {
        let headers: HTTPHeaders = ["Authorization" : "KakaoAK 7ec366f0297ccf8930b9a5288ea66b22"]
        let parameters: Parameters = ["query" : regionName]
        
        let request = AF.request(baseURLString + reigoncode2CoordURLString, method: .get, parameters: parameters, headers: headers)
        
        request.responseDecodable(of: Reigoncode2Coord.self) { response in
            if let error = response.error {
                print(error)
                return
            }
            
            guard let value = response.value,
                  let location = value.documents.first,
                  let y = Double(location.y), let x = Double(location.x) else {
                print("data is nil")
                return
            }
            
            print(location)
            completionHandler(y, x)
        }
    }
    
    func requestRegioncode(by location: (Double, Double), completionHandler: @escaping (String) -> ()) {
        let parameters: Parameters = ["x" : location.0, "y": location.1] // longitude, latitude
        let headers: HTTPHeaders = ["Authorization" : "KakaoAK 7ec366f0297ccf8930b9a5288ea66b22"]
        
        let request = AF.request(baseURLString + coord2regioncodeURLString, method: .get, parameters: parameters, headers: headers)
        
        request.responseDecodable(of: Coord2regioncode.self) { response in
            if let error = response.error {
                print(error)
                return
            }
            
            guard let value = response.value else {
                print("response is nil")
                return
            }
            
            print(value)
            
            guard let location = value.documents.first, let addressName = location.normalAddress?.name else {
                print("location is nil")
                return
            }
             
            print(value)
            completionHandler(addressName)
        }
    }
}


// ---> Reigoncode2Coord

struct Reigoncode2Coord: Codable {
    let documents: [Coord]
}

struct Coord: Codable {
    let y: String
    let x: String
}

// ---> Coord2regioncode

struct Coord2regioncode: Codable {
    let documents: [Region]
}

struct Region: Codable {
    let loadAddress: LoadAddress?
    let normalAddress: NormalAddress?
    
    enum CodingKeys: String, CodingKey {
        case loadAddress = "road_address"
        case normalAddress = "address"
    }
}

struct NormalAddress: Codable {
    let name: String
    
    enum CodingKeys: String, CodingKey {
        case name = "address_name"
    }
}

struct LoadAddress: Codable {
    let name: String
    
    enum CodingKeys: String, CodingKey {
        case name = "address_name"
    }
}

