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
    
    @Published var isLoading               : Bool = false
    @Published private var checkout        : CheckoutViewModel?
    @Published private var shoppingCartData: ShoppingCartData?
    @Published var lineItems_OOS           : [LineItemViewModel] = [] {
        didSet {
            lineItem_OOS_isChanged = true
        }
    }
    var lineItem_OOS_isChanged: Bool = false
    var userEnv: UserEnviroment? = nil
    
    // MARK: checkout
    var cartItemsCountingNum: Int { checkout?.lineItems.reduce(0, { $0 + $1.quantity}) ?? 0 }
    
    var lineItems: [LineItemViewModel] {
        var tempLineItems:[LineItemViewModel] = []
        for lineItem in checkout?.lineItems ?? [] {
            let availableQuantity = lineItem.variant?.quantityAvailable ?? 0
            if availableQuantity > 0 {
                tempLineItems.append(lineItem)
            } else {
                if !lineItems_OOS.contains(where: { $0.variantID == lineItem.variantID }) {
                    lineItems_OOS.append(lineItem)
                }
            }
        }
        return tempLineItems
    }
    
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
    
    var noticeMessage: String {
        shoppingCartData?.locationMessages?.textViewFormat() ?? ""
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
    func fetchCheckout(needAsync: Bool = true) {
        
        guard let userEnv = userEnv else { return }
        
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
            if let checkout = checkout {
                self.checkout = checkout
                self.asyncShoppingCart()
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
    
    
    // MARK: Init
    func deleteLocalCheckout() {
        self.checkout         = nil
        self.shoppingCartData = nil
    }
}
