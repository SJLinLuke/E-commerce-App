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
    @Published var quantity                  : Int = 1
    
    var cartEnv           : CartEnvironment?
    var product           : ProductBody?
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
    
    func tapAddToCart() {
        
        guard let currentItem = product, let cartEnv = cartEnv else { return }
        
        let tempLineItems     = cartEnv.lineItems
        let variantID         = currentItem.variants?[0].shopify_product_variant_id
        let inventoryQuantity = currentItem.inventory_quantity ?? 0
        
        if let existingLineItem = tempLineItems.first(where: { $0.variantID?.shopifyIDEncode == variantID }) {
            existingLineItem.quantity += quantity
            if existingLineItem.quantity > inventoryQuantity {
                alertItem = AlertContext.quantityUnavailable
                return
            }
            cartEnv.mutateItem(lineItems: tempLineItems)
        } else {
            if let variants = currentItem.variants, variants.indices.contains(0) {
                let newItem = CartItem(variant: variants[0], quantity: quantity)
                if newItem.quantity > inventoryQuantity {
                    alertItem = AlertContext.quantityUnavailable
                    return
                }
                cartEnv.mutateItem(lineItems: tempLineItems, addCartItem: newItem)
            }
        }
        
        isShowAddToCartButtonSheet = false
        NotificationCenter.default.post(name: Notification.Name.addToCart_Popup, object: nil)
    }
}
