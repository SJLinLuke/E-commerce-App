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
    @Published var product: ProductBody = ProductBody(description_html: "", is_favourite: false, shopify_product_id: "", title: "1 Itailian Veal Tongue [Previous Forzen] (300g)", variants: nil, options: nil, logistic_tags: nil, image_src: "", inventory_quantity: 0, compare_at_price: "40", price: "69.00", images: nil, products: nil, similar_products: nil)
    
    var isCompareWithPrice: Bool {        
        return product.compare_at_price != nil
    }
    
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
