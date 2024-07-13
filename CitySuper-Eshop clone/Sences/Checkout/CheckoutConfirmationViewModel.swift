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
    
    var alertManager: AlertManager?
    
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
    func applyDiscount(_ code: String,_ codes:[String]? = nil, complete: ((CheckoutViewModel) -> Void)? = nil) {
        
        if let complete, let codes {
            // for multiple disocunts apply
            var _codes = codes
            Client.shared.applyDiscount(codes.first ?? "", to: checkout?.id ?? "") { checkout in
                if let checkout {
//                    self.checkout = checkout
                    _codes.removeFirst()
                    if !_codes.isEmpty {
                        self.applyDiscount("", _codes, complete: complete)
                    } else {
                        complete(checkout)
                    }
                }
            }
        } else {
            // for singal disocunt apply
            guard !isLoading else { return }
            
            self.isLoading = true
            Client.shared.applyDiscount(code, to: checkout?.id ?? "") { checkout in
                if let checkout {
                    let unAppliableDiscounts = self.collectUnAppliableDiscounts(checkout.discountApplication ?? [])
                    self.checkout = checkout
                    self.isLoading = false
                    if !unAppliableDiscounts.isEmpty {
                        self.alertManager?.callStaticAlert(AlertContext.discountDisApplied(unAppliableDiscounts))
                    } else {
                        if self.isDiscountAppliable(code) {
                            self.alertManager?.callStaticAlert(AlertContext.discountApplied)
                        } else {
                            self.alertManager?.callStaticAlert(AlertContext.discountDisApplied([code]))
                        }
                    }
                    self.objectWillChange.send()
                }
            }
        }
    }
    
    func removeDiscount(_ code: String) {
        
        guard !isLoading else { return }
        
        var appliedDiscounts:[String] = Array(discountApplication.map({ discount in
            if let _discount = discount as? DiscountCodeViewModel {
                return _discount.name
            }
            return ""
        }))
        
        appliedDiscounts = appliedDiscounts.filter({ !$0.isEmpty })
        appliedDiscounts = appliedDiscounts.filter({ $0 != code })
        
        self.isLoading = true
        
        Client.shared.removeDiscount(checkoutID: checkout?.id ?? "") { checkout in
            if let checkout {
                self.checkout = checkout
                if !appliedDiscounts.isEmpty {
                    self.applyDiscount("", appliedDiscounts) { checkout in
                        self.checkout = checkout
                        self.isLoading = false
                    }
                } else {
                    self.isLoading = false
                }
            }
        }
    }
    
    private func collectUnAppliableDiscounts(_ currentDiscounts: [DiscountApplication]) -> [String] {
        guard !currentDiscounts.isEmpty else { return [] }
        let previousDiscounts = self.discountApplication
        let currentDiscounts = Set(currentDiscounts.map { $0.name })
        let unAppliableDiscounts = previousDiscounts.compactMap { discount in
            if let discountViewModel = discount as? DiscountCodeViewModel {
                if !currentDiscounts.contains(discountViewModel.name) {
                    return discountViewModel
                }
            }
            return nil
        }
        return Array(unAppliableDiscounts.map() { $0.name })
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
