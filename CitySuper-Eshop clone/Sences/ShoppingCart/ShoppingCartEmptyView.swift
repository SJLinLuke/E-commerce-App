//
//  ShoppingCartEmptyView.swift
//  CitySuper-Eshop clone
//
//  Created by LukeLin on 2024/6/13.
//

import SwiftUI

struct ShoppingCartEmptyView: View {
    var body: some View {
        ZStack {
            Color(hex: "F7F7F7")
                .ignoresSafeArea(.all)
            VStack {
                Image("empty_cart_icon")
                    .resizable()
                    .frame(width: 40, height: 35)
                Text("Your shopping cart is empty")
                    .font(.callout)
                    .padding(.top, 40)
                Spacer()
                
            }
            .padding(.top, 90)
        }
    }
}

#Preview {
    ShoppingCartEmptyView()
}
