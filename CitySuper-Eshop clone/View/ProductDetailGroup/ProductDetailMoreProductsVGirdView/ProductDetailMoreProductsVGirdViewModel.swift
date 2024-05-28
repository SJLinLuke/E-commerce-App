//
//  ProductDetailMoreProductsVGirdViewModel.swift
//  CitySuper-Eshop clone
//
//  Created by LukeLin on 2024/5/28.
//

import Foundation

@MainActor final class ProductDetailMoreProductsVGirdViewModel: ObservableObject {
    
    @Published var isLoading   : Bool = false
    @Published var isHasMore   : Bool = true
    @Published var moreProducts: [ProductBody] = []
    
    private var page: Int = 1
    
    func fetchMoreProducts(_ type: String, id: String) {
        
        guard !isLoading && isHasMore else { return }
        
        Task {
            do {
                self.isLoading = true
                
                let moreProducts = type == "Related Products" ?
                try await NetworkManager.shared.fetchRelatedProduct(id, page: page) :
                try await NetworkManager.shared.fetchSimilarProduct(id, page: page)
                
                if moreProducts.count > 0 {
                    self.moreProducts.append(contentsOf: moreProducts)
                    self.page += 1
                } else {
                    self.isHasMore = false
                }
                self.isLoading = false
            } catch {
                self.isLoading = false
                print(error.localizedDescription)
            }  
        }
    }
}
