//
//  CheckoutConfirmationViewModel.swift
//  CitySuper-Eshop clone
//
//  Created by LukeLin on 2024/7/1.
//

import Foundation
import MobileBuySDK

@MainActor final class CheckoutConfirmationViewModel: ObservableObject {
    
    @Published var isLoading: Bool = false
    
    @Published private var checkout: CheckoutViewModel
    @Published var checkedDate     : String
    @Published var selectedStore   : Locations?
    @Published var address         : AddressViewModel?
    @Published var checkoutMethod  : CheckoutMethodsType
    
    init(checkout: CheckoutViewModel, checkedDate: String, selectedStore: Locations?, address: AddressViewModel?, checkoutMethod: CheckoutMethodsType) {
        self.checkout = checkout
        self.checkedDate = checkedDate
        self.checkoutMethod = checkoutMethod
        if let selectedStore { self.selectedStore = selectedStore }
        if let address { self.address = address }
    }
    
    var lineItems: [LineItemViewModel] { checkout.lineItems }
    
    var shippingPrice: Decimal { checkout.shippingRatePrice }
    
    var subTotal: Decimal { checkout.lineItems.reduce(0, { $0 + ($1.variant?.price ?? 0) * Decimal($1.quantity) })}
    
    var totalPrice: Decimal { checkout.totalPrice }
    
    var isDelivery: Bool { checkoutMethod == .delivery }
    
    var shippingAddress: String { checkout.shippingAddress?.fullAddress ?? "" }
    
    var discountApplication: [DiscountApplication] { checkout.discountApplication ?? [] }
    
    // MARK: init (shipping ... etc)
    func initCheckout() {
        
        guard !isLoading else { return }
        
        self.isLoading = true
        Client.shared.pollForReadyCheckout(checkout.id) { checkout in
            if let checkout {
                self.checkout = checkout
                if self.checkoutMethod == .delivery {
                    Client.shared.updateShippingLine(by: checkout.id, shippingLineHandle: checkout.shippingRateHandle) { checkout in
                        if let checkout {
                            self.checkout = checkout
                            self.isLoading = false
                            self.objectWillChange.send()
                        }
                    }
                } else {
                    self.isLoading = false
                    self.objectWillChange.send()
                }
            }
        }
    }
    
    func applyDiscount(_ code: String) {
        
        guard !isLoading else { return }
        
        self.isLoading = true
        Client.shared.applyDiscount(code, to: checkout.id) { checkout in
            if let checkout {
                self.checkout = checkout
                self.isLoading = false
                self.objectWillChange.send()
            }
        }
    }
}
