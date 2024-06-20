//
//  SearchModel.swift
//  CitySuper-Eshop clone
//
//  Created by LukeLin on 2024/6/18.
//

import Foundation

struct SearchSuggestionResponse: Decodable {
    let success      : Bool
    let error_message: String?
    let data         : SearchSuggestionData
}

struct SearchSuggestionData: Decodable, Hashable, Equatable {
    let hot_keywords         : [String]
    let recommend_collections: [recommendKeywords]
}

struct recommendKeywords: Decodable, Hashable, Equatable, Identifiable {
    var id = UUID()
    let shopify_storefront_id: String
    let image_src            : String?
    let not_viewable         : [String]
    
    enum CodingKeys: CodingKey {
        case shopify_storefront_id
        case image_src
        case not_viewable
    }

    init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        self.shopify_storefront_id = try container.decode(String.self, forKey: .shopify_storefront_id)
        self.image_src             = try container.decodeIfPresent(String.self, forKey: .image_src)
        self.not_viewable          = try container.decode([String].self, forKey: .not_viewable)
    }
}


struct SearchKeywordResponse: Decodable {
    let success      : Bool
    let error_message: String?
    let data         : SearchKeywordData
}

struct SearchKeywordData: Decodable, Hashable, Equatable {
    var brands             : [String]? = nil
    var collections        : [SearchKeywordCollection]? = nil
    var product_collections: [SearchKeywordCollection]? = nil
    var suggest_products   : [ProductBody]? = nil
    var products           : [ProductBody]? = nil
}

struct SearchKeywordCollection: Decodable, Hashable, Equatable {
    let shopify_storefront_id: String?
    let title                : String
    let not_viewable         : [String]?
    let image_src            : String?
    let item_count           : Int?
}


struct SearchResultResponse: Decodable {
    let success: Bool
    let error_message: String?
    let data: SearchResultData
}

struct SearchResultData: Decodable {
    let current_page    : String?
    let total_page      : Int?
    let total_record    : Int?
    var products        : [ProductBody]? = nil
    var suggest_products: [ProductBody]? = nil
}


struct SearchResultCollectionResponse: Decodable {
    let success      : Bool
    let error_message: String?
    let data         : SearchResultCollectionData
}

struct SearchResultCollectionData: Decodable {
    let total_record       : Int
    var product_collections: [SearchKeywordCollection]? = nil
}

