//
//  CartEnvironment.swift
//  CitySuper-Eshop clone
//
//  Created by LukeLin on 2024/6/8.
//

import Foundation
import MobileBuySDK

@MainActor final class CartEnvironment: ObservableObject {
    typealias Task = _Concurrency.Task
    
    @Published var isLoading: Bool = false
    @Published private var checkout : CheckoutViewModel?
    @Published private var shoppingCartData: ShoppingCartData?
    
    var userEnv: UserEnviroment? = nil
    
    // MARK: checkout
    var cartItemsCountingNum: Int { checkout?.lineItems.reduce(0, { $0 + $1.quantity}) ?? 0 }
    
    var lineItems: [LineItemViewModel] { checkout?.lineItems ?? [] }
    
    var subTotal: Decimal { checkout?.lineItems.reduce(0, { $0 + ($1.variant?.price.amount ?? 0) * Decimal($1.quantity) }) ?? 0}
    
    var totalPrice: Decimal { checkout?.totalPrice ?? 0 }
    
    var totalDiscount: Decimal { checkout?.totalDiscounts ?? 0 }
    
    var discountApplication: [DiscountApplication] { checkout?.discountApplication ?? [] }
    
    // MARK: shoppingCartData
    var isAllowToCheckout: Bool {
        if !(shoppingCartData?.allowToCheckout ?? false) {
            return false
        }
        if lineItems.isEmpty || shoppingCartData?.location_options?.isEmpty ?? true {
            return false
        }
        return true
    }
    
    var noticeMessage: String {
        shoppingCartData?.locationMessages?.textViewFormat() ?? ""
    }
    
    func getLogicTag(shopifyID: String) -> [LogisticTag] {
        guard let shoppingCartProducts = self.shoppingCartData?.products else { return [] }
        print(shopifyID)
        for product in shoppingCartProducts {
            if product.variants?[0].shopify_product_variant_id == shopifyID {
                return product.logistic_tags ?? []
            }
        }
        return []
    }
    
    // MARK: Network fetch
    func fetchCheckout(needAsync: Bool = true) {
        
        guard let userEnv = userEnv, !isLoading else { return }
        
        self.isLoading = true
        Client.shared.pollForReadyCheckout(userEnv.checkoutID) { checkout in
            if let checkout = checkout {
                self.checkout = checkout
                if needAsync {
                    self.asyncShoppingCart()
                } else {
                    self.isLoading = false
                }
            }
        }
    }
    
    private func asyncShoppingCart() {
        Task {
            do {
                self.shoppingCartData = try await NetworkManager.shared.uploadShoppingCart(lineItems: lineItems)
                self.isLoading = false
            } catch {
                print(error.localizedDescription)
                self.isLoading = false
            }
        }
    }
    
    // MARK: Init
    func deleteLocalCheckout() {
        self.checkout         = nil
        self.shoppingCartData = nil
    }
}
