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

struct VerifyResponse: Codable {
    let success     : Bool
    let errorMessage: String?
    var data        : String? = nil
}

struct VerifyRequest: Encodable {
    let email: String
    let otp  : String
}

struct UpdatePasswordResponse: Codable {
    var success: Bool
    var error_message: String?
}

struct UpdatePasswordRequest: Encodable {
    let new_password: String
    let password: String
}

