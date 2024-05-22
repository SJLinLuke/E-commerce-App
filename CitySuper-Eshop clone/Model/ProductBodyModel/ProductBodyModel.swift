//
//  ProductBodyModel.swift
//  CitySuper-Eshop clone
//
//  Created by LukeLin on 2024/5/11.
//

import Foundation

struct SimilarRelatedProductResponse: Decodable {
    let success: Bool
    let error_message: String?
    let data: [ProductBody]
}

struct ProductResponse: Decodable {
    let success: Bool
    let error_message: String?
    let data: ProductBody
}

struct ProductBody: Decodable, Equatable, Hashable {
    
    let description_html  : String?
    let is_favourite      : Bool
    let shopify_product_id: String
    let title             : String
    
    let variants          : [ProductVariant]?
    let options           : [ProductOption]?
    let logistic_tags     : [LogisticTag]?
    
    let image_src         : String?
    let inventory_quantity: Int?
    let compare_at_price  : String?
    let price             : String?
    
    let images            : [ProductImage]?
    
    /// these are not for using now (fetch by api/eshop/similarProducts/ and api/eshop/relatedProducts/)
    var products          : [ProductBody]? /// related products
    var similar_products  : [ProductBody]? /// similar products
        
    //    func convertToProductViewModel() -> ProductViewModel? {
    //
    //        do {
    //            let type = try Storefront.Product(fields: [
    //                "id": shopify_product_id,
    //                "descriptionHtml":description_html ?? "",
    //                "title":title,
    ////                "variants": [Storefront.ProductVariantConnection(fields: [
    //////                    "id": UUID().uuidString,
    ////                    "shopify_product_id" : shopify_product_id,
    ////                    "descriptionHtml":description_html ?? "",
    ////                    "title":title,
    ////                ])],
    //                "variants" : "[]",
    //    //            "price":Decimal(string: price ?? "0"),
    //    //            "comparePrice": Decimal(string: compare_at_price ?? "0")
    //
    //            ])
    //            let model = ProductViewModel(from: type)
    //        return model
    //        }
    //        catch {
    //        print(error)
    //        }
    //
    //        return nil
    //    }
}

struct ProductOption: Codable, Equatable, Hashable {
    let shopify_product_option_id: Int?
    let name                     : String?
    let values                   : [String]?
}

struct LogisticTag: Codable, Equatable, Hashable {
    let bullet_point: String?
    let tag_name    : String
    let type        : String
}

struct ProductImage: Codable, Equatable, Hashable {
    let src     : String?
    let width   : Double
    let height  : Double
}
