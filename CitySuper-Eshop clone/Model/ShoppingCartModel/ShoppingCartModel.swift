//
//  CartModel.swift
//  CitySuper-Eshop clone
//
//  Created by LukeLin on 2024/6/9.
//

import Foundation

struct ShoppingCartRequest: Encodable {
    let shopify_variant_id: String
    let quantity          : Int
}

struct ShoppingCartResponse: Decodable {
    let success: Bool
    let error_message: String?
    let data: ShoppingCartData
}

struct ShoppingCartData: Decodable {
    
    struct CartTimeItemResponse: Decodable {
        let dayOfWeek: String?
        let startTime: String?
        let endTime  : String?
    }
    
    let allowToCheckout             : Bool?
    let locationMessages            : [String]?
    let products                    : [ProductBody]?
    let location_options            : [String]?
    let store_pickup_locations      : [Locations]
    let delivery_lead_time          : Int?
    let store_pickup_lead_time      : Int?
    let delivery_start_date         : String?
    let store_pickup_start_date     : String?
    let store_pickup_end_date       : String?
    let delivery_end_date           : String?
    let store_pickup_blackout_dates : [String]?
    let delivery_blackout_dates     : [String]?
    let store_pickup_available_dates: [String]?
    let delivery_available_dates    : [String]?
    let store_pickup_time           : [CartTimeItemResponse]?
    let delivery_time               : [CartTimeItemResponse]?
    let store_pickup_date_picker    : Bool?
    let delivery_date_picker        : Bool?
    let paypal                      : Bool?
    let stripe                      : Bool?
}

struct Locations: Decodable, Hashable {
    let province           : String?
    let city               : String?
    let address1           : String?
    let address2           : String?
    let country            : String?
    let shopify_location_id: Int
    let name               : String?
    let open_at            : String?
    let close_at           : String?
    let preparation_time   : Int?
    let available_dates    : [String]?
}
