//
//  QuantitySelectorView.swift
//  CitySuper-Eshop clone
//
//  Created by LukeLin on 2024/6/9.
//

import SwiftUI

struct QuantitySelectorView: View {
    
    @EnvironmentObject private var cartEnv: CartEnvironment
    
    @StateObject private var addToCartVM = AddToCartButtomSheetViewModel.shared
    
    @State private var isAlertShow: Bool = false
    @State private var alertItem  : AlertItem? {
        didSet {
            self.isAlertShow.toggle()
        }
    }
    
    @Binding var quantity: Int
    
    var mode     : UIMode = .normal
    var lineItem : LineItemViewModel?
    
    var body: some View {
        HStack {
            Button {
                tapMinus()
            } label: {
                Image("minus_icon")
                    .padding(3) // make more tap area
            }
            .frame(width: 28, height: 28)
            .background(Color(hex: "D6D6D6"))
            .cornerRadius(3)
            
            Text("\(lineItem?.quantity ?? quantity)")
                .multilineTextAlignment(.center)
                .keyboardType(.numberPad)
                .frame(width: 25)
                .font(.subheadline)
            
            Button {
                tapPlus()
            } label: {
                Image("plus_icon")
                    .padding(3) // make more tap area
            }
            .frame(width: 28, height: 28)
            .background(.themeDarkGreen)
            .cornerRadius(3)
        }
        .overlay {
            RoundedRectangle(cornerRadius: 3)
                .stroke(.secondary, lineWidth: 0.3)
        }
        .modifier(AlertModifier(alertItem: alertItem, isAlertShow: $isAlertShow))
    }
    
    func tapMinus() {
        
        if mode == .cart {
            
            guard let lineItem = lineItem, lineItem.quantity > 1 && !cartEnv.isLoading else { return }
            
            lineItem.quantity -= 1
            
            let tempLineItems = cartEnv.lineItems
            for item in tempLineItems {
                if item.variantID?.shopifyIDEncode == lineItem.variantID?.shopifyIDEncode {
                    item.quantity = lineItem.quantity
                }
            }
            
            cartEnv.mutateItem(lineItems: tempLineItems)
        } else {
            // addToCart should handle here
            guard self.quantity > 1  else { return }
            
            self.quantity -= 1
        }
    }
    
    func tapPlus() {
        if mode == .cart {
            
            guard let lineItem = lineItem , lineItem.quantity < lineItem.variant?.quantityAvailable ?? 0, !cartEnv.isLoading else {
                self.alertItem = AlertContext.quantityUnavailable
                return
            }
            
            lineItem.quantity += 1
            
            let tempLineItems = cartEnv.lineItems
            for item in tempLineItems {
                if item.variantID?.shopifyIDEncode == lineItem.variantID?.shopifyIDEncode {
                    item.quantity = lineItem.quantity
                }
            }
            
            cartEnv.mutateItem(lineItems: tempLineItems)
        } else {
            // addToCart should handle here
            guard self.quantity < addToCartVM.product?.inventory_quantity ?? 0 else {
                self.alertItem = AlertContext.quantityUnavailable
                return
            }
            self.quantity += 1
        }
    }
}

//#Preview {
//    QuantitySelectorView(lineItem: )
//        .environmentObject(CartEnvironment())
//}
