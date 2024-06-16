//
//  ProductBodyModel.swift
//  CitySuper-Eshop clone
//
//  Created by LukeLin on 2024/5/11.
//

import Foundation

struct SimilarRelatedProductResponse: Decodable {
    let success      : Bool
    let error_message: String?
    let data         : [ProductBody]
}

struct ProductResponse: Decodable {
    let success      : Bool
    let error_message: String?
    let data         : ProductBody
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
        
    static func mockData() -> ProductBody {
        return ProductBody(description_html: "", is_favourite: false, shopify_product_id: "", title: "1 Italian Veal Tongue [PreViously Frozen] (300g)", variants: nil, options: nil, logistic_tags: nil, image_src: "", inventory_quantity: 0, compare_at_price: "40", price: "69.99", images: nil, products: nil, similar_products: nil)
    }
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

extension LogisticTag {
    var typeImage: String {
        var path: String = "store_icon"
        
        switch self.type {
            case "PickupOption":
                path = "pickuponly_icon"
            
            case "PickupOptionGeneral" :
                path = "pickuponly_icon"
            
            case "LeadtimeOption":
                path = "leadtime_icon"
            
            case "DeliveryOption":
                path = "deliveryonly_icon"
            
            case "ShipmentOption":
                path = "period_icon"
            
            case "ShipmentOptionGeneral":
                path = "period_icon"
            
            default:
                path = "store_icon"
        }
        return path
    }
}
