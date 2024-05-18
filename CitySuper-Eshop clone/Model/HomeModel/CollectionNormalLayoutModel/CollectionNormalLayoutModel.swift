//
//  CollectionNormalLayoutModel.swift
//  CitySuper-Eshop clone
//
//  Created by LukeLin on 2024/5/11.
//

import Foundation

struct CollectionNormalLayoutModel: Decodable {
    let title                : String
    let layout               : String
    var products             : [ProductBody]
    let shopify_collection_id: String
    var not_viewable         : [String]?
}
