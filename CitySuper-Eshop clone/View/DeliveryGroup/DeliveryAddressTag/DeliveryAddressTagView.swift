//
//  DeliveryAddressTagView.swift
//  CitySuper-Eshop clone
//
//  Created by LukeLin on 2024/6/29.
//

import SwiftUI

struct DeliveryAddressTagView: View {
    
    @EnvironmentObject private var cartEnv: CartEnvironment

    let address: AddressViewModel
    
    var body: some View {
        HStack(spacing: 10) {
            Circle()
                .frame(width: 15)
                .foregroundColor(.clear)
                .overlay {
                    RoundedRectangle(cornerRadius: 50)
                        .stroke(.secondary, lineWidth: 0.5)
                    if let currentSelectedAddress = cartEnv.currentSelectedAddress,
                        address == currentSelectedAddress {
                        Circle()
                            .frame(width: 5.5)
                            .foregroundColor(.themeDarkGreen)
                    }
                }
                .shadow(radius: 10)
                .padding(.leading, 10)
            
            HStack {
                Text(address.fullAddress)
                    .padding(8)
                    .lineSpacing(5)
                    .font(.callout)
                    .fontWeight(.regular)
                    .foregroundColor(Color(hex: "666666"))
                
                Spacer()
            }
            .overlay {
                RoundedRectangle(cornerRadius: 5)
                    .stroke(Color(hex: "D2D2D2") ,lineWidth: 1)
            }
            .background(Color(hex: "F2F2F2"))
        }
        .padding(EdgeInsets(top: 10, leading: 20, bottom: 10, trailing: 20))
    }
}

//#Preview {
//    DeliveryAddressTagView(address: )
//        .environmentObject(CartEnvironment())
//}
