//
//  ProductCollectionModel.swift
//  CitySuper-Eshop clone
//
//  Created by LukeLin on 2024/5/24.
//

import Foundation

struct ProductCollectionResponse: Decodable {
    let success      : Bool
    let error_message: String?
    let data         : ProductCollectionData?
}

struct ProductCollectionData: Decodable {
    let shopify_collection_id        : String
    var title                        : String
    let image                        : ProductImage?
    let is_18_above                  : Int
    let collection_page_tab_1_title  : String?
    let collection_page_tab_1_content: String?
    let collection_page_tab_2_title  : String?
    let collection_page_tab_2_content: String?
    let collection_page_tab_3_title  : String?
    let collection_page_tab_3_content: String?
    let description_html             : String?
}

struct CollectionProductsResponse: Decodable {
    let success      : Bool
    let error_message: String?
    let data         : CollectionProductsData?
}

struct CollectionProductsData: Decodable {
    let total: Int?
    let data : [ProductBody]?
}
