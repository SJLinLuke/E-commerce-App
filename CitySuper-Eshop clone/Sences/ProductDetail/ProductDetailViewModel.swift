//
//  ProductDetailViewModel.swift
//  CitySuper-Eshop clone
//
//  Created by LukeLin on 2024/5/21.
//

import Foundation

@MainActor final class ProductDetailViewModel: ObservableObject {
    
    static let shared = ProductDetailViewModel()
    
    @Published var isLoading: Bool = false
    @Published var product  : ProductBody? {
        didSet {
            self.isFavourite = FavVM.isFavourite(shopifyID: product?.shopify_product_id.shopifyIDEncode ?? "")
        }
    }
    @Published var relatedProducts: [ProductBody] = []
    @Published var similarProducts: [ProductBody] = []
    @Published var isFavourite    : Bool = false
    
    private var FavVM = FavouriteViewModel.shared

    private var isRelatedHasMore: Bool = true
    private var isSimilarHasMore: Bool = true
    
    private var relatedPage: Int = 1
    private var similarPage: Int = 1
    
    var isCompareWithPrice: Bool { product?.compare_at_price != nil }
    var isSoldOut: Bool { product?.inventory_quantity == 0 }
    
    init() {
        self.isRelatedHasMore = true
        self.isSimilarHasMore = true
        self.relatedPage = 1
        self.similarPage = 1
    }
    
    func fetchProduct(shopifyID: String) {
        
        guard !isLoading else { return }
        
        Task {
            do {
                self.isLoading = true
                self.product = try await NetworkManager.shared.fetchProduct(shopifyID)
                self.fetchSimilarProduct(shopifyID: shopifyID)
                self.fetchRelatedProduct(shopifyID: shopifyID)
                self.isLoading = false
            } catch {
                print(error.localizedDescription)
                self.isLoading = false
            }
        }
    }
    
    func fetchSimilarProduct(shopifyID: String) {
        
        guard isSimilarHasMore else { return }
        
        Task {
            do {
                let similarProductData = try await NetworkManager.shared.fetchSimilarProduct(shopifyID, page: self.similarPage)
                
                if similarProductData.count > 0 {
                    self.similarProducts.append(contentsOf: similarProductData)
                    self.similarPage += 1
                } else {
                    self.isSimilarHasMore = false
                }
            } catch {
                print(error.localizedDescription)
            }
        }
    }
    
    func fetchRelatedProduct(shopifyID: String) {
        
        guard isRelatedHasMore else { return }
        
        Task {
            do {
                let relatedProductData = try await NetworkManager.shared.fetchRelatedProduct(shopifyID, page: self.relatedPage)
                
                if relatedProductData.count > 0 {
                    self.relatedProducts.append(contentsOf: relatedProductData)
                    self.relatedPage += 1
                } else {
                    self.isRelatedHasMore = false
                }
            } catch {
                print(error.localizedDescription)
            }
        }
    }
    
}
