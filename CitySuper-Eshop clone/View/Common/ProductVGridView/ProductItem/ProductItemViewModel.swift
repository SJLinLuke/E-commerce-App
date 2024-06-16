//
//  ProductViewModel.swift
//  CitySuper-Eshop clone
//
//  Created by LukeLin on 2024/5/12.
//

import Foundation

@MainActor final class ProductItemViewModel: ObservableObject {
    
    static let shared = ProductItemViewModel()
    
    @Published var product: ProductBody? {
        didSet {
            self.isFavourite = FavVM.isFavourite(shopifyID: product?.shopify_product_id ?? "")
        }
    }
    
    @Published var isFavourite: Bool = false
    
    private var FavVM = FavouriteViewModel.shared
    
    var isSoldOut: Bool { product?.inventory_quantity == 0 }
    var isCompareWithPrice: Bool { product?.compare_at_price != nil }

    func getProductImageSrc() -> String {
        guard let images = self.product?.images, images.count > 0 else { return "" }
        
        return images[0].src ?? ""
    }
}
