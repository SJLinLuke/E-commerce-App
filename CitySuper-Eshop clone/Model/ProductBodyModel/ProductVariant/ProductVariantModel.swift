//
//  ProductVariantModel.swift
//  CitySuper-Eshop clone
//
//  Created by LukeLin on 2024/5/11.
//

import Foundation
import MobileBuySDK

struct ProductVariant: Codable, Equatable, Hashable {
    
    let option1: String?
    let option2: String?
    let option3: String?
    
    let shopify_product_variant_id: String
    let title                     : String
    let price                     : String?
    let compare_at_price          : String?
    let inventory_quantity        : Int?
    let shopify_product_id        : String?
    
    func asJSON() -> [String: Any] {
        return ["option1"                   : option1 ?? "",
                "option2"                   : option2 ?? "",
                "option3"                   : option3 ?? "",
                "shopify_product_variant_id": shopify_product_variant_id,
                "title"                     : title,
                "price"                     : price ?? "",
                "compare_at_price"          : compare_at_price ?? "",
                "inventory_quantity"        : inventory_quantity ?? 0,
                "shopify_product_id"        : shopify_product_id ?? ""]
    }
    
    static func fromVM(item: VariantNodeViewModel) -> ProductVariant?{

        let json: [String: Any] = [
            "option1"                   : "",
            "option2"                   : "",
            "option3"                   : "",
            "shopify_product_variant_id": item.id,
            "title"                     : item.title,
            "price"                     : item.price.formattedAmount,
            "compare_at_price"          : item.comparePrice.formattedAmount,
            "inventory_quantity"        : item.quantityAvailable,
            "shopify_product_id"        : item.product_id
        ]
        
        let data = try! JSONSerialization.data(withJSONObject: json, options: .fragmentsAllowed)
        let decoder = JSONDecoder()
        
        do {
            let pv = try decoder.decode(ProductVariant.self, from: data)
            return pv
        } catch {
            return nil
        }
    }
    
    static func fromOrderVM(item: Storefront.ProductVariant) -> ProductVariant? {
        // 确保ID值和title是字符串
        guard let variantID = item.id.rawValue as? String,
              let productID = item.product.id.rawValue as? String,
              let title = item.title as? String else {
            return nil
        }
        
        let json: [String: Any] = [
            "option1"                   : "",
            "option2"                   : "",
            "option3"                   : "",
            "shopify_product_variant_id": variantID,
            "title"                     : title,
            "price"                     : "",
            "compare_at_price"          : "",
            "inventory_quantity"        : 0,
            "shopify_product_id"        : productID
        ]
        
        if let data = try? JSONSerialization.data(withJSONObject: json, options: .fragmentsAllowed) {
            let decoder = JSONDecoder()
            
            do {
                let pv = try decoder.decode(ProductVariant.self, from: data)
                return pv
            } catch {
                print("Decoding error: \(error)")
                return nil
            }
        }
        return nil
    }

}
