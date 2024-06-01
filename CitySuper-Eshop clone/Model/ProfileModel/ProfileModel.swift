//
//  ProfileModel.swift
//  CitySuper-Eshop clone
//
//  Created by LukeLin on 2024/5/14.
//

import Foundation

struct MutipassTokenResponse: Decodable {
    let success      : Bool
    let error_message: String?
    let data         : MutipassTokenData?
}

struct MutipassTokenData: Decodable {
    let multipass_token: String
}

struct LoginBody: Encodable {
    let username: String
    let password: String
}

struct LoginResponse: Decodable {
    let success      : Bool
    let error_message: String?
    let data         : LoginData?
}

struct LoginData: Codable {
    let va_account         : String
    let token              : String
    let current_checkout_id: String
    let profile            : ProfileData
}

struct ProfileData: Codable {
    let loyaltyMax      : Int?
    let upgradeRequired : Int?
    let englishName     : String?
    let memberType      : String?
    let schemeEffectDate: String?
    var anniversaryDate : String?
    var loyaltyPts      : String?
    let accountNumber   : String?
    let asOfDate        : String?
    let memberUpgradePts: Decimal?
    let ytdSpending     : Decimal?
    let user_group      : [Int]?
    let changePassword  : Bool?
}

struct ProfileRowModel: Identifiable, Equatable {
    let id = UUID()
    
    let title        : String
    let icon         : String
    let seperateType : Bool
}
