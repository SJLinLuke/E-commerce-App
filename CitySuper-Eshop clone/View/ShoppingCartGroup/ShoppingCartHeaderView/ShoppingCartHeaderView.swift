//
//  ShoppingHeaderView.swift
//  CitySuper-Eshop clone
//
//  Created by LukeLin on 2024/6/11.
//

import SwiftUI

struct ShoppingCartHeaderView: View {
    
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
                
            } label: {
                Text("Clean all")
                    .font(.callout)
                    .fontWeight(.heavy)
                    .foregroundColor(.secondary)
            }
        }
        .padding()
    }
}

#Preview {
    ShoppingCartHeaderView(cartItemsNum: 10)
}
