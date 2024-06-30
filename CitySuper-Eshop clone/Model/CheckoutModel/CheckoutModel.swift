//
//  CheckoutModel.swift
//  CitySuper-Eshop clone
//
//  Created by LukeLin on 2024/6/30.
//

import Foundation

struct CloneToCheckoutResponse: Decodable {
    let success      : Bool
    let error_message: String?
    let data         : String
}

