//
//  QuantitySelectorView.swift
//  CitySuper-Eshop clone
//
//  Created by LukeLin on 2024/6/9.
//

import SwiftUI

struct QuantitySelectorView: View {
    
    @EnvironmentObject private var cartEnv: CartEnvironment
    
    @State private var isAlertShow: Bool = false
    @State private var alertItem  : AlertItem? {
        didSet {
            self.isAlertShow.toggle()
        }
    }
    
    @Binding var quantity: Int
    
    let variantID        : String
    let inventoryQuantity: Int
    var mode             : UIMode = .normal
    
    var body: some View {
        HStack {
            Button {
                tapMinus()
            } label: {
                Image("minus_icon")
            }
            .frame(width: 28, height: 28)
            .background(Color(hex: "D6D6D6"))
            .cornerRadius(3)
            
            TextField("", value: $quantity, formatter: NumberFormatter())
                .multilineTextAlignment(.center)
                .keyboardType(.numberPad)
                .frame(width: 25)
                .font(.subheadline)
            
            Button {
                tapPlus()
            } label: {
                Image("plus_icon")
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
            
            guard quantity > 1 && !cartEnv.isLoading else { return }
            
            quantity -= 1
            
            let tempLineItems = cartEnv.lineItems
            for item in tempLineItems {
                if item.variantID?.shopifyIDEncode == variantID {
                    item.quantity = quantity
                }
            }
            
            cartEnv.mutateItem(lineItems: tempLineItems)
        } else {
            // addToCart should handle here
            guard quantity > 1  else { return }
            
            quantity -= 1
        }
    }
    
    func tapPlus() {
        if quantity < inventoryQuantity {
            
            if mode == .cart {
                
                guard !cartEnv.isLoading else { return }
                
                quantity += 1
                
                let tempLineItems = cartEnv.lineItems
                for item in tempLineItems {
                    if item.variantID?.shopifyIDEncode == variantID {
                        item.quantity = quantity
                    }
                }
                
                cartEnv.mutateItem(lineItems: tempLineItems)
            } else {
                // addToCart should handle here
                quantity += 1
            }
        } else {
            self.alertItem = AlertContext.quantityUnavailable
        }
    }
}

#Preview {
    QuantitySelectorView(quantity: .constant(10), variantID: "", inventoryQuantity: 20)
        .environmentObject(CartEnvironment())
}
