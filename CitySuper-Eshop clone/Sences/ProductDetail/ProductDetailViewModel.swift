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
    @Published var product: ProductBody?
    @Published var relatedProducts: [ProductBody] = []
    @Published var similarProducts: [ProductBody] = []
    
    private var isRelatedHasMore: Bool = true
    private var isSimilarHasMore: Bool = true
    
    private var relatedPage: Int = 1
    private var similarPage: Int = 1
    
    var isCompareWithPrice: Bool {
        product?.compare_at_price != nil
    }
    
    var isSoldOut: Bool {
        product?.inventory_quantity == 0
    }
    
    func fetchProduct(shopifyID: String) {
        guard !isLoading else { return }
        
        DispatchQueue.main.async {
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
    }
    
    func fetchSimilarProduct(shopifyID: String) {
        
        guard isSimilarHasMore else { return }
        
        DispatchQueue.main.async {
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
    }
    
    func fetchRelatedProduct(shopifyID: String) {
        
        guard isRelatedHasMore else { return }
        
        DispatchQueue.main.async {
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
    
    func logisticTypeImage(type: String) -> String{
        
        var path: String = "store_icon"
        
        switch type {
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
