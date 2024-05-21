//
//  ProductDetailViewModel.swift
//  CitySuper-Eshop clone
//
//  Created by LukeLin on 2024/5/21.
//

import Foundation

@MainActor final class ProductDetailViewModel: ObservableObject {
    
    @Published var isLoading: Bool = false
    @Published var product: ProductBody = ProductBody(description_html: "", is_favourite: false, shopify_product_id: "", title: "1 Itailian Veal Tongue [Previous Forzen] (300g)", variants: nil, options: nil, logistic_tags: nil, image_src: "", inventory_quantity: 0, compare_at_price: "40", price: "69.00", images: nil, products: nil, similar_products: nil)
    
    func fetchProduct(shopifyID: String) {
        guard !isLoading else { return }
        
        DispatchQueue.main.async {
            Task {
                do {
                    self.isLoading = true
                    self.product = try await NetworkManager.shared.fetchProduct(shopifyID)
                    self.isLoading = false
                } catch {
                    print(error.localizedDescription)
                    self.isLoading = false
                }
            }
        }
    }
    
}
