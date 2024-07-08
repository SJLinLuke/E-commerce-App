//
//  OTPModel.swift
//  CitySuper-Eshop clone
//
//  Created by LukeLin on 2024/7/8.
//

import Foundation

struct OTPResponse: Decodable {
    let success: Bool
    let error_message: String?
}

struct OTPRequest: Encodable {
    let app  : String
    let email: String
}
