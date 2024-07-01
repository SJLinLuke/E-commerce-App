//
//  CartEnvironment.swift
//  CitySuper-Eshop clone
//
//  Created by LukeLin on 2024/6/8.
//

import Foundation
import MobileBuySDK

enum CheckoutMethodsType: String {
    case delivery = "Delivery"
    case pickup   = "Pickup"
}

@MainActor final class CartEnvironment: ObservableObject {
    
    typealias Task = _Concurrency.Task
    
    @Published var isLoading                 : Bool = false
    @Published var isShowDeliveryOrPickup    : Bool = false
    @Published var isShowCheckoutConfirmation: Bool = false
    @Published var checkout                  : CheckoutViewModel?
    @Published private var shoppingCartData  : ShoppingCartData?
    
    @Published var lineItems_OOS           : [LineItemViewModel] = []
    @Published var lineItems               : [LineItemViewModel] = []
    @Published var currentMethod           : CheckoutMethodsType = .delivery
    @Published var currentSelectedAddress  : AddressViewModel?
    @Published var currentSelectedDate     : String = ""
    @Published var currentSelectedStore    : Locations?
    @Published var isCheckSaveAddress      : Bool = false
    
    let addDeliveryAddressVM = AddDeliveryAddressViewModel.shared

    var lineItem_OOS_isChanged: Bool = false
    var userEnv: UserEnviroment? = nil
    
    // MARK: checkout
    var cartItemsCountingNum: Int { checkout?.lineItems.reduce(0, { $0 + $1.quantity}) ?? 0 }

    var subTotal: Decimal { checkout?.lineItems.reduce(0, { $0 + ($1.variant?.price ?? 0) * Decimal($1.quantity) }) ?? 0}
    
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
    
    var noticeMessage: String { shoppingCartData?.locationMessages?.textViewFormat() ?? "" }
    
    var availableMethods: [CheckoutMethodsType] 
    {
        var tempMethods: [CheckoutMethodsType] = []
        if shoppingCartData?.location_options?.contains("Delivery") ?? false {
            tempMethods.append(.delivery)
        }
        if shoppingCartData?.location_options?.contains("StorePickup") ?? false {
            tempMethods.append(.pickup)
        }
        return tempMethods
    }
    
    var deliveryPicker: Bool {
        shoppingCartData?.delivery_date_picker ?? true &&
        !(shoppingCartData?.delivery_available_dates?.isEmpty ?? false)
    }
    
    var deliveryStartDate: String { shoppingCartData?.delivery_start_date ?? "" }
    var deliveryEndDate  : String { shoppingCartData?.delivery_end_date ?? "" }
    
    var pickupStartDate  : String { shoppingCartData?.store_pickup_start_date ?? "" }
    var pickupEndDate    : String { shoppingCartData?.store_pickup_end_date ?? "" }
    
    func getPickupLocations(_ locationCity: String) -> [Locations] {
        guard let pickupLocations = self.shoppingCartData?.store_pickup_locations else { return [] }
        var tempLocations = pickupLocations
        if locationCity == "ALL" {
            return pickupLocations
        } else {
            tempLocations = tempLocations.filter { Location in Location.city == locationCity }
            return tempLocations
        }
    }
    
    func getLogicTag(shopifyID: String) -> [LogisticTag] {
        guard let shoppingCartProducts = self.shoppingCartData?.products else { return [] }
        for product in shoppingCartProducts {
            if product.variants?[0].shopify_product_variant_id == shopifyID, let logistic_tags = product.logistic_tags {
                return logistic_tags
            }
        }
        return []
    }
    
    
    // MARK: Network fetch
    func fetchCheckout(needAsync: Bool = true, complete: (() -> Void)? = nil) {
        
        guard let userEnv = userEnv else { return }
        
        self.isLoading = true
        Client.shared.pollForReadyCheckout(userEnv.checkoutID) { checkout in
            if let checkout {
                self.checkout = checkout
                self.checkoutOOS(lineItems: checkout.lineItems) { lineItems in
                    self.lineItems = lineItems
                    if let complete = complete {
                        complete()
                    }
                    if needAsync {
                        self.asyncShoppingCart()
                    } else {
                        self.isLoading = false
                    }
                }
            }
        }
    }
    
    private func asyncShoppingCart() {
        Task {
            do {
                self.shoppingCartData = try await NetworkManager.shared.uploadShoppingCart(lineItems: lineItems)
                self.isLoading = false
                
                if lineItem_OOS_isChanged {
                    self.lineItem_OOS_isChanged = false
                    self.mutateItemToCheckout(lineItems: self.lineItems)
                }
                
            } catch {
                print(error.localizedDescription)
                self.isLoading = false
            }
        }
    }

    @objc private func executePendingMutations(addCartItem: CartItemWrapper? = nil) {
        
        guard let userEnv = userEnv, let lastMutationsToExecute = pendingMutations.last else { return }
        
        self.isLoading = true
        
        pendingMutations.removeAll()
        
        Client.shared.MutateItemToCheckout(with: lastMutationsToExecute, addCartItem: addCartItem?.cartItem, of: GraphQL.ID(rawValue: userEnv.checkoutID)) { checkout in
            if let checkout {
                self.checkout = checkout
                self.checkoutOOS(lineItems: checkout.lineItems) { lineItems in
                    self.lineItems = lineItems
                    self.asyncShoppingCart()
                }
            }
        }
    }
    
    private func cloneToCheckout(complete: @escaping (String?) -> Void) {
        
        guard let userEnv = userEnv else { return }
        
        Task {
            do {
                let clonedCheckoutID = try await NetworkManager.shared.cloneToCheckout(userEnv.checkoutID)
                complete(clonedCheckoutID)
            } catch {
                complete(nil)
                print(error.localizedDescription)
            }
        }
    }
    

    // MARK: Operations
    private var pendingMutations: [[LineItemViewModel]] = []
    private var debounceWorkItem: DispatchWorkItem?
    
    func mutateItem(lineItems: [LineItemViewModel], addCartItem: CartItem? = nil) {
        self.mutateItemToCheckout(lineItems: lineItems, addCartItem: addCartItem)
    }

    private func mutateItemToCheckout(lineItems: [LineItemViewModel], addCartItem: CartItem? = nil) {
        
        guard let _ = userEnv, !isLoading else { return }
        
        pendingMutations.append(lineItems)
        
        if let addCartItem = addCartItem {
            executePendingMutations(addCartItem: CartItemWrapper(cartItem: addCartItem))
        } else {
            debounce(#selector(executePendingMutations), delay: 0.4)
        }
    }
    
    private func debounce(_ selector: Selector, delay: TimeInterval) {
        // Cancel any existing work item to prevent previous tasks from executing
        debounceWorkItem?.cancel()
        
        // Create a new work item to execute the function
        debounceWorkItem = DispatchWorkItem { [weak self] in
            self?.executePendingMutations()
        }
        
        // Schedule the work item after the specified delay
        if let workItem = debounceWorkItem {
            DispatchQueue.main.asyncAfter(deadline: .now() + delay, execute: workItem)
        }
    }
    
    // MARK: OOS
    private func checkoutOOS(lineItems: [LineItemViewModel], complete: @escaping([LineItemViewModel]) -> Void) {
        var tempLineItems:[LineItemViewModel] = []
        for lineItem in lineItems {
            let availableQuantity = lineItem.variant?.quantityAvailable ?? 0
                        
            if availableQuantity >= lineItem.quantity {
                tempLineItems.append(lineItem)
            }
            
            if availableQuantity < lineItem.quantity {
                self.lineItem_OOS_isChanged = true
                lineItem.quantity = availableQuantity
                tempLineItems.append(lineItem)
            }
            
            if availableQuantity == 0 {
                if !lineItems_OOS.contains(where: { $0.variantID == lineItem.variantID }) {
                    self.lineItems_OOS.append(lineItem)
                    self.lineItem_OOS_isChanged = true
                }
                tempLineItems = tempLineItems.filter({ tempLineItem in
                    tempLineItem != lineItem
                })
            }
        }
        complete(tempLineItems)
    }
    
    // MARK: TapOnCheckout
    func tapOnCheckout() {
        
        guard !isLoading else { return }
        
        self.fetchCheckout {
            if !self.availableMethods.isEmpty, !self.lineItem_OOS_isChanged {
                self.currentMethod        = self.availableMethods.first ?? .delivery
                self.currentSelectedDate  = self.shoppingCartData?.delivery_available_dates?.first ?? ""
                self.currentSelectedStore = self.shoppingCartData?.store_pickup_locations.first
                self.isShowDeliveryOrPickup.toggle()
            }
        }
    }
    
    func tapConfirm() {
        
        guard !isLoading else { return }
        
        self.isLoading = true
        
        var address: Storefront.MailingAddressInput?
        var attributesInput: [Storefront.AttributeInput] = []
        
        if currentMethod == .delivery {
            guard !self.currentSelectedDate.isEmpty else {
                print("No date selected")
                self.isLoading = false
                return
            }
            
            if let selectedDeliveryAddress = self.currentSelectedAddress {
                address = selectedDeliveryAddress.addressInput
            } else {
                address = addDeliveryAddressVM.creatInput()
                
                if self.isCheckSaveAddress, address != nil {
                    self.addDeliveryAddressVM.addAddress { debugPrint("address saved") }
                }
            }
            attributesInput = [Storefront.AttributeInput.create(key: "Delivery Date", value: self.currentSelectedDate)]
        }
       
        if currentMethod == .pickup {
            guard !self.currentSelectedDate.isEmpty else {
                print("No date selected")
                self.isLoading = false
                return
            }
            
            if let selectedStore = self.currentSelectedStore {
                address = addDeliveryAddressVM.creatInput(store: selectedStore)
                
                attributesInput = [
                    Storefront.AttributeInput.create(key: "Pickup Date", value: self.currentSelectedDate),
                    Storefront.AttributeInput.create(key: "Pickup Location", value: String(selectedStore.shopify_location_id))]
            }
            
        }
        
        guard let address = address else {
            print("delivery: please fill in address / pickup: please select a pickup store")
            self.isLoading = false
            return
        }
        
        self.cloneToCheckout { checkoutID in
            if let checkoutID = checkoutID {
                Client.shared.updateCheckout(checkoutID, updatingCompleteShippingAddress: address) { checkout in
                    if let checkout {
                        self.checkout = checkout
                        Client.shared.updateAttributes(checkout.id, attributes: attributesInput) { checkout in
                            if let checkout {
                                self.checkout = checkout
                                self.isLoading = false
                                self.isShowCheckoutConfirmation.toggle()
                            }
                        }
                    }
                }
            }
        }
        
    }
    
    // MARK: Init
    func deleteLocalCheckout() {
        self.checkout         = nil
        self.shoppingCartData = nil
    }
}
