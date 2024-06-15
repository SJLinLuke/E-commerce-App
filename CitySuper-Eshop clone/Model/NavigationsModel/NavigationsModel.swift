//
//  NavigationsModel.swift
//  CitySuper-Eshop clone
//
//  Created by LukeLin on 2024/6/15.
//

import Foundation

struct NavigationsResponse: Decodable {
    let success      : Bool
    let error_message: String?
    let data         : [NavigationsData]
}

struct NavigationsData: Decodable, Hashable, Equatable {
    let shopify_collection_id: String
    var title                : String
    let hot_brands           : [HotBrand]?
    var sub_collections      : [NavigationsData]?
    var not_viewable         : [String]?
}

struct HotBrand: Decodable, Hashable, Equatable  {
    let shopify_collection_id: String
    let image_src: String?
}

struct SubHistory: Hashable, Equatable {
    let title      : String
    let collections: [NavigationsData]
}
