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

struct
