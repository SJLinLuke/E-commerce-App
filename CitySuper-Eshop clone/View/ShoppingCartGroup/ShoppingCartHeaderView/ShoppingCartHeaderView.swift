//
//  ShoppingHeaderView.swift
//  CitySuper-Eshop clone
//
//  Created by LukeLin on 2024/6/11.
//

import SwiftUI

struct ShoppingCartHeaderView: View {
    
    @EnvironmentObject private var cartEnv: CartEnvironment
    
    @State var alertItem  : AlertItem?
    @State var isAlertShow: Bool = false
    
    let cartItemsNum: Int
    
    var body: some View {
        HStack {
            var cartCountingNum: AttributedString {
                var result: AttributedString = ""
                var cart = AttributedString("Cart:")
                cart.foregroundColor = .secondary
                cart.font = .callout
                var countingNum = AttributedString("  \(cartItemsNum) items")
                countingNum.font = .system(.callout, weight: .heavy)
                countingNum.foregroundColor = .secondary
                
                result = cart + countingNum
                return result
            }
            
            Text(cartCountingNum)
            
            Spacer()
            
            Button {
                tapCleanAll()
            } label: {
                Text("Clean all")
                    .font(.callout)
                    .fontWeight(.heavy)
                    .foregroundColor(.secondary)
            }
        }
        .padding()
        .modifier(AlertModifier(alertItem: alertItem, isAlertShow: $isAlertShow))
    }
    
    func tapCleanAll() {
        self.alertItem = AlertContext.clearCart
        self.alertItem?.buttons.append(AlertButton(title: "No", action: {}))
        self.alertItem?.buttons.append(AlertButton(title: "Yes", action: {
            // clear all cart items
            let carItem: [LineItemViewModel] = []
            cartEnv.mutateItem(lineItems: carItem)
        }))
        self.isAlertShow = true
    }
}

#Preview {
    ShoppingCartHeaderView(cartItemsNum: 10)
}
