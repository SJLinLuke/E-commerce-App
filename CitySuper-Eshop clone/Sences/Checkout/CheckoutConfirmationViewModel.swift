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
    
    @Published private var checkout: CheckoutViewModel?
    @Published var checkedDate     : String?
    @Published var selectedStore   : Locations?
    @Published var address         : AddressViewModel?
    @Published var checkoutMethod  : CheckoutMethodsType?
    
    init(checkout: CheckoutViewModel?, checkedDate: String?, selectedStore: Locations?, address: AddressViewModel?, checkoutMethod: CheckoutMethodsType?) {
        if let checkout { self.checkout = checkout }
        if let checkedDate { self.checkedDate = checkedDate }
        if let checkoutMethod { self.checkoutMethod = checkoutMethod }
        if let selectedStore { self.selectedStore = selectedStore }
        if let address { self.address = address }
    }
    
    var lineItems: [LineItemViewModel] { checkout?.lineItems ?? [] }
    
    var shippingPrice: Decimal { checkout?.shippingRatePrice ?? 0.0 }
    
    var subTotal: Decimal { checkout?.lineItems.reduce(0, { $0 + ($1.variant?.price ?? 0) * Decimal($1.quantity) }) ?? 0.0}
    
    var totalPrice: Decimal { checkout?.totalPrice ?? 0.0 }
    
    var isDelivery: Bool { checkoutMethod == .delivery }
    
    var shippingAddress: String { checkout?.shippingAddress?.fullAddress ?? "" }
    
    var discountApplication: [DiscountApplication] { checkout?.discountApplication ?? [] }
    
    // MARK: init (shipping ... etc)
    func initCheckout() {
        
        guard !isLoading else { return }
        
        self.isLoading = true
        Client.shared.pollForReadyCheckout(checkout?.id ?? "") { checkout in
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
    
    
    // MARK: Discount (shipping ... etc)
    func applyDiscount(_ code: String) {
        
        guard !isLoading else { return }
        
        self.isLoading = true
        Client.shared.applyDiscount(code, to: checkout?.id ?? "") { checkout in
            if let checkout {
                self.checkout = checkout
                if self.isDiscountAppliable(code) {
                    self.isLoading = false
                    print("discount is applied")
                } else {
                    self.isLoading = false
                    print("discount is not appliable")
                }
                self.objectWillChange.send()
            }
        }
    }
    
    private func isDiscountAppliable(_ code: String) -> Bool {
        guard let discount = discountApplication.last as? DiscountCodeViewModel else { return false }
        return discount.name == code
    }
    
    func calculateDiscountPrice(_ code: String) -> Decimal {
        var price: Decimal = 0.0
        for item in lineItems {
            for discountAllocation in item.discountAllocations {
                if let application = discountAllocation.application as? DiscountCodeViewModel {
                    if (code == application.name) {
                        price += discountAllocation.amount
                    }
                }
            }
        }
        return price
    }
    
    func isDiscountUsed(_ code: String) -> Bool {
        let hash_discountApplication = Set(discountApplication.map(){ $0.name })
        return hash_discountApplication.contains(code)
    }
    
}
