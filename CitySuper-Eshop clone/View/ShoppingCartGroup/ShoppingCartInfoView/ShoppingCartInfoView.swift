//
//  ShoppingCartInfoView.swift
//  CitySuper-Eshop clone
//
//  Created by LukeLin on 2024/6/11.
//

import SwiftUI

struct ShoppingCartInfoView: View {
    
    @EnvironmentObject private var cartEnv: CartEnvironment
    
    var body: some View {
        VStack {
            CustomFormTextItem(leadingText: "SubTotal",
                               trailingText: Currency.stringFrom(cartEnv.subTotal),
                               leadingColor: Color(hex: "777777"),
                               trailingFont: .bold)
            
            if !cartEnv.discountApplication.textViewFormat(seperated: false).isEmpty {
                CustomFormTextItem(leadingText: cartEnv.discountApplication.textViewFormat(seperated: false),
                                   trailingText: "-\(Currency.stringFrom(cartEnv.totalDiscount))",
                                   leadingColor: Color(hex: "777777"),
                                   trailingColor: Color(hex: "E85321"),
                                   alignment: .bottom)
            }
            
            SeperateLineView(color: .commonBackGroundGray, height: 1.5)
            
            HStack(alignment: .bottom) {
                VStack(alignment: .leading) {
                    Text("Total")
                        .foregroundColor(Color(hex: "777777"))
                        .padding(.bottom, 5)
                    Text(Currency.stringFrom(cartEnv.totalPrice))
                        .fontWeight(.bold)
                        .font(.system(size: 16))
                }
                
                Spacer()
                
                Button {
                    
                } label: {
                    ThemeButton(title: "Checkout",
                                font: .regular,
                                width: 170,
                                iconPath: "check_icon",
                                disable: !cartEnv.isAllowToCheckout)
                }
                .disabled(!cartEnv.isAllowToCheckout)
            }
            .padding(.bottom, -10)
        }
        .padding()
        .background(.white)
        .overlay(alignment: .top) {
            SeperateLineView(color: .commonBackGroundGray, height: 1.5)
        }
    }
}

#Preview {
    ShoppingCartInfoView()
        .environmentObject(CartEnvironment())
}
