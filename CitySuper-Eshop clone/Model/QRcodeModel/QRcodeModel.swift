//
//  QRcodeModel.swift
//  CitySuper-Eshop clone
//
//  Created by LukeLin on 2024/5/18.
//

import Foundation

struct QRcodeResponse: Decodable {
    let success      : Bool
    let error_message: String?
    let data         : QRcodeData?
}

struct QRcodeData: Codable {
    let qrcode     : String
    let expiry_date: String
}
