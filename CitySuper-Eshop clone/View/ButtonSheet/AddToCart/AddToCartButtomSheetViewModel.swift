//
//  AddToCartButtomSheetViewModel.swift
//  CitySuper-Eshop clone
//
//  Created by LukeLin on 2024/6/8.
//

import Foundation

@MainActor final class AddToCartButtomSheetViewModel: ObservableObject {
    
    static let shared = AddToCartButtomSheetViewModel()
    
    @Published var alertItem  : AlertItem? {
        didSet {
            self.isAlertShow = true
        }
    }
    @Published var isAlertShow               : Bool = false
    @Published var isLoading                 : Bool = false
    @Published var isShowAddToCartButtonSheet: Bool = false
    
    var product: ProductBody?
    
    var isCompareWithPrice: Bool { product?.compare_at_price != nil }
    
    func isProductSoldOut(shopifyID: String, completed: @escaping (Bool) -> Void) {
        
        guard !isLoading && !shopifyID.isEmpty else { return }
        
        Task {
            do {
                self.isLoading = true
                let product = try await NetworkManager.shared.fetchProduct(shopifyID)
                self.product = product
                self.isLoading = false
                completed(product.inventory_quantity == 0)
            } catch {
                print(error.localizedDescription)
                self.isLoading = false
                completed(true)
            }
            
        }
    }
}
