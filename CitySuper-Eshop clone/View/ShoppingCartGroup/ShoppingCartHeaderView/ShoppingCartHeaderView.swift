//
//  ShoppingHeaderView.swift
//  CitySuper-Eshop clone
//
//  Created by LukeLin on 2024/6/11.
//

import SwiftUI

struct ShoppingCartHeaderView: View {
    
    @EnvironmentObject private var cartEnv: CartEnvironment

    @StateObject private var alertManager = AlertManager()
    
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
        .modifier(AlertModifier(alertItem: alertManager.alertItem, isAlertShow: $alertManager.isShowAlert))
    }
    
    func tapCleanAll() {
        var alert = AlertContext.clearCart
        alert.buttons.append(AlertButton(title: "No", action: {}))
        alert.buttons.append(AlertButton(title: "Yes", action: {
            // clear all cart items
            let carItem: [LineItemViewModel] = []
            cartEnv.mutateItem(lineItems: carItem)
        }))
        alertManager.callStaticAlert(alert)
    }
}

#Preview {
    ShoppingCartHeaderView(cartItemsNum: 10)
}
