//
//  OrderHistoryModel.swift
//  CitySuper-Eshop clone
//
//  Created by LukeLin on 2024/5/19.
//

import Foundation

struct OrderResponse: Decodable {
    let success: Bool
    let error_message: String?
    let data: [OrderData]?
}

struct OrderData: Decodable {
    let shopify_order_id : String
    let note             : String?
    let custom_attributes: [[String: String]]?
    let payment_method   : PaymentMethod?
}

struct PaymentMethod: Decodable {
    let type: String
    let card: PaymentCard
}

struct PaymentCard: Decodable {
    let last4: String
    let brand: String
}

