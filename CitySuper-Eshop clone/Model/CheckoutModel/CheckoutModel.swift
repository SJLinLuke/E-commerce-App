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

struct CheckoutToOrderResponse: Decodable {
    let success      : Bool
    let error_message: String?
    let data         : CheckoutToOrderData
}

struct CheckoutToOrderData: Decodable {
    let id              : Int
    let financial_status: String?
    let order_number    : Int?
}

