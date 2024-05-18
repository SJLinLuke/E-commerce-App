//
//  ProductViewModel.swift
//  CitySuper-Eshop clone
//
//  Created by LukeLin on 2024/5/12.
//

import Foundation

final class ProductItemViewModel: ObservableObject {
    
    @Published var product: ProductBody?
    
    var isSoldOut: Bool {
        product?.inventory_quantity == 0
    }
    
    var isCompareWithPrice: Bool {
        guard product?.compare_at_price != nil else { return false }
        
        return true
    }
}
