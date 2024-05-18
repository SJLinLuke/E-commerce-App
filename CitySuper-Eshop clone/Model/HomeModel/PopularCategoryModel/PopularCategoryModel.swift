//
//  PopularCategoryModel.swift
//  CitySuper-Eshop clone
//
//  Created by LukeLin on 2024/5/11.
//

import Foundation

struct PopularCategoryModel: Decodable {
    let layout    : String?
    let title     : String?
    var categories: [PopularCategory]
}

struct PopularCategory: Decodable, Hashable, Equatable {
    let image_src            : String?
    let shopify_collection_id: String
    let title                : String
    let products             : [ProductBody]?
    var not_viewable         : [String]?
}
