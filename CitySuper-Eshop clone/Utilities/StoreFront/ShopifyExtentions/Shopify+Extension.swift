//
//  Shopify_Extension.swift
//  CitySuper-Eshop clone
//
//  Created by LukeLin on 2024/5/27.
//

import Foundation

extension [DiscountApplication] {

    func textViewFormat(seperated: Bool = true) -> String {
        // seenNames checking is for mutiple duplicate discount name
        var seenNames = Set<String>()
        return self.compactMap { discount in
            guard !seenNames.contains(discount.name) else {
                return nil
            }
            seenNames.insert(discount.name)
            return discount.name
        }.joined(separator: "\(seperated ? " /" : "")\n")
    }
    
}
