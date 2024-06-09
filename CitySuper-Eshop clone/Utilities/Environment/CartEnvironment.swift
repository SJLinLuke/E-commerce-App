//
//  CartEnvironment.swift
//  CitySuper-Eshop clone
//
//  Created by LukeLin on 2024/6/8.
//

import Foundation
import MobileBuySDK

@MainActor final class CartEnvironment: ObservableObject {
        
    @Published var isLoading: Bool = false
    @Published private var checkout : CheckoutViewModel?
    
    var userEnv: UserEnviroment? = nil
    
    var cartItemsCountingNum: Int { checkout?.lineItems.reduce(0, { $0 + $1.quantity}) ?? 0 }
    
    var lineItems: [LineItemViewModel] { checkout?.lineItems ?? [] }
    
    var subTotal: Decimal { checkout?.lineItems.reduce(0, { $0 + ($1.variant?.price.amount ?? 0) * Decimal($1.quantity) }) ?? 0}
    
    var totalPrice: Decimal { checkout?.totalPrice ?? 0 }
    
    var totalDiscount: Decimal { checkout?.totalDiscounts ?? 0 }
    
    var discountApplication: [DiscountApplication] { checkout?.discountApplication ?? [] }
    
    func fetchCheckout() {
        
        guard let userEnv = userEnv, !isLoading else { return }
        
        self.isLoading = true
        Client.shared.pollForReadyCheckout(userEnv.checkoutID) { checkout in
            if let checkout = checkout {
                self.checkout = checkout
                self.isLoading = false
            }
        }
    }
    
}
