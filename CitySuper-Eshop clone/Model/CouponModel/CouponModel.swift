//
//  CouponModel.swift
//  CitySuper-Eshop clone
//
//  Created by LukeLin on 2024/6/2.
//

import Foundation

struct CouponResponse: Decodable {
    let success      : Bool
    let error_message: String?
    let data         : [CouponData]
}

struct CouponData: Decodable, Equatable, Hashable {    
    let discount_id    : String?
    let discount_code  : String
    let description    : String?
    let valid_to       : String?
    let type           : String?
    var typeFromInfoAPI: String?
    var category       : String?
    let price          : Int?
    let tnc            : String?
    var isScan         : Bool? = false
}
