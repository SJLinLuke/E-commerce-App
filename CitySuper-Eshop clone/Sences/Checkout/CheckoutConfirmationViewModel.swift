//
//  CheckoutConfirmationViewModel.swift
//  CitySuper-Eshop clone
//
//  Created by LukeLin on 2024/7/1.
//

import Foundation
import MobileBuySDK

@MainActor final class CheckoutConfirmationViewModel: ObservableObject {
    
    @Published private var checkout   : CheckoutViewModel?
    @Published var checkedDate: String
    
    init(checkout: CheckoutViewModel? = nil, checkedDate: String) {
        self.checkout = checkout
        self.checkedDate = checkedDate
    }
    
    var lineItems: [LineItemViewModel] { self.checkout?.lineItems ?? [] }
    
    var shippingPrice: Decimal { checkout?.shippingDiscount ?? 0.0 }
    
    var subTotal: Decimal { checkout?.lineItems.reduce(0, { $0 + ($1.variant?.price ?? 0) * Decimal($1.quantity) }) ?? 0}
    
    var totalPrice: Decimal { checkout?.totalPrice ?? 0 }
}
