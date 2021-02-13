//
//  GeoCoding.swift
//  zipkok
//
//  Created by won heo on 2021/01/15.
//

import Foundation
import CoreLocation
import Alamofire

final class GeoCodingApi {
    static let shared = GeoCodingApi()
    
    private let baseURLString = "https://dapi.kakao.com"
    private let reigoncode2CoordURLString = "/v2/local/search/address.json"
    private let coord2regioncodeURLString = "/v2/local/geo/coord2address.json"
    
    private init() {}
    
    func requestCoord(by regionName: String, completionHandler: @escaping (String, String) -> ()) {
        let headers: HTTPHeaders = ["Authorization" : "KakaoAK 7ec366f0297ccf8930b9a5288ea66b22"]
        let parameters: Parameters = ["query" : regionName]
        
        let request = AF.request(baseURLString + reigoncode2CoordURLString, method: .get, parameters: parameters, headers: headers)
        
        request.responseDecodable(of: Reigoncode2Coord.self) { response in
            if let error = response.error {
                print(error)
                return
            }
            
            guard let value = response.value, let location = value.documents.first else {
                print("data is nil")
                return
            }
            
            completionHandler(location.y, location.x)
        }
    }
    
    func requestRegioncode(by coordinate: (Double, Double), errorHandler: (() -> ())? = nil, completionHandler: @escaping (String, String) -> ()) {
        let x = floor(coordinate.0 * 10000)/10000
        let y = floor(coordinate.1 * 10000)/10000
        let parameters: Parameters = ["x" : x, "y": y] // longitude, latitude
        let headers: HTTPHeaders = ["Authorization" : "KakaoAK 7ec366f0297ccf8930b9a5288ea66b22"]
        
        let request = AF.request(baseURLString + coord2regioncodeURLString, method: .get, parameters: parameters, headers: headers)
        
        request.responseDecodable(of: Coord2regioncode.self) { response in
            if let error = response.error {
                print(error)
                errorHandler?()
                return
            }
            
            guard let value = response.value, let location = value.documents.first, let normalAddress = location.normalAddress?.name else {
                print("---> response is nil")
                print(response)
                errorHandler?()
                return
            }
                        
            // 도로명 없이 내보낼 때 예외 처리
            guard let loadAddressName = location.loadAddress?.name else {
                completionHandler(normalAddress, normalAddress)
                return
            }
            
            print(x, y)
            print(value.documents)
            completionHandler(normalAddress, loadAddressName)
        }
    }
    
    func geoLocation(location clLocation: CLLocation, errorHandler: (() -> ())? = nil, completionHandler: @escaping (String) -> ()) {
        let geo = CLGeocoder()
        
        geo.reverseGeocodeLocation(clLocation, completionHandler: { (placemarks, error) in
            if error == nil, let last = placemarks?.last {                
                let city: String = last.subAdministrativeArea ?? ""
                // let town: String = last.locality ?? ""
                let name: String = last.name ?? ""

                let address: String = "\(name), \(city)"
                completionHandler(address)
            }
        })
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

// ---> LocationVc

struct LocationInfo {
    let latitude: String
    let longitude: String
    let normalName: String
    let loadName: String
}


