//
//  ProductVariantModel.swift
//  CitySuper-Eshop clone
//
//  Created by LukeLin on 2024/5/11.
//

import Foundation



struct ProductVariant: Codable, Equatable, Hashable {
    
    let option1: String?
    let option2: String?
    let option3: String?
    
    let shopify_product_variant_id: String
    let title: String
    let price: String?
    let compare_at_price: String?
    let inventory_quantity: Int?
    let shopify_product_id: String?
    
//    func asJSON() -> [String: Any] {
//        return ["option1": option1 ?? "",
//                "option2": option2 ?? "",
//                "option3": option3 ?? "",
//                "shopify_product_variant_id": shopify_product_variant_id,
//                "title": title,
//                "price": price ?? "",
//                "compare_at_price": compare_at_price ?? "",
//                "inventory_quantity": inventory_quantity ?? 0,
//                "shopify_product_id": shopify_product_id ?? ""]
//    }
    
//    static func fromVM(item: VariantNodeViewModel) -> ProductVariant?{
//        
//        let json: [String: Any] = [
//            "option1": "",
//           "option2":  "",
//           "option3":  "",
//            "shopify_product_variant_id": item.id,
//            "title": item.productTitle,
//            "price": item.price.formattedAmount,
//           "compare_at_price": item.comparePrice.formattedAmount,
//            "inventory_quantity": item.quantityAvailable,
//            "shopify_product_id": item.product_id
//        ]
//        
//        let data = try! JSONSerialization.data(withJSONObject: json, options: .prettyPrinted)
//        let decoder = JSONDecoder()
//        do {
//            let pv = try decoder.decode(ProductVariant.self, from: data)
//            return pv
//        } catch {
//            return nil
//        }
//        
//    }
    
}

extension Decimal {
    var formattedAmount: String? {
        let formatter = NumberFormatter()
        formatter.generatesDecimalNumbers = true
        formatter.minimumFractionDigits = 2
        formatter.maximumFractionDigits = 2
        return formatter.string(from: self as NSDecimalNumber)
    }
}
