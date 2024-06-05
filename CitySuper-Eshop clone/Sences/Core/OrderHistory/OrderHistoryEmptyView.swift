//
//  OrderHistoryEmptyView.swift
//  CitySuper-Eshop clone
//
//  Created by LukeLin on 2024/6/5.
//

import SwiftUI

struct OrderHistoryEmptyView: View {
    var body: some View {
        ZStack {
            Color(hex: "F7F7F7").ignoresSafeArea(.all)
            VStack {
                Image("empty_cart_icon")
                    .resizable()
                    .frame(width: 45, height: 40)
                    
                Text("You have no order history")
                    .padding(.top, 40)
                
                Spacer()
            }
            .padding(.top, 40)
        }
        .padding(.top, -10)
    }
}

#Preview {
    OrderHistoryEmptyView()
}
