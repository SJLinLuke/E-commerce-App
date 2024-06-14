//
//  ShoppingCartOOSCell.swift
//  CitySuper-Eshop clone
//
//  Created by LukeLin on 2024/6/15.
//

import SwiftUI

struct ShoppingCartOOSCell: View {
    
    @EnvironmentObject private var cartEnv: CartEnvironment
    
    let lineItem: LineItemViewModel
    
    var body: some View {
        HStack(spacing: 3) {
            SeperateLineView(color: Color(hex: "E94E1B"),
                             height: .infinity, width: 5)
                
            HStack {
                RemoteImageView(url: lineItem.variant?.image?.absoluteString ?? "", placeholder: .common)
                    .frame(width: 45, height: 45)
               
                VStack(alignment: .leading) {
                    Label(
                        title: {
                            Text("This item is currently out of stock.")
                                .fontWeight(.medium)
                        },
                        icon: {
                            Image("info_icon")
                                .renderingMode(.template)
                            
                        }
                    )
                    .foregroundColor(Color(hex: "858585"))
                    
                    Text(lineItem.title)
                        .padding(.bottom, 5)
                }
                .lineLimit(1)
                .font(.system(size: 14))
                .padding(.leading, 5)
            }
            
            Spacer()
            
            XDismissButton(isShow: .constant(true),
                           color: Color(hex: "D1D1D1"),
                           width: 15, height: 15, onComplete: {
                deleteOOSLineItem()
            })
            .padding(.trailing)
        }
        .frame(height: 65)
        .background(.white)
        .padding(5)
    }
    
    func deleteOOSLineItem() {
        cartEnv.lineItems_OOS = cartEnv.lineItems_OOS.filter({ $0.variantID?.shopifyIDEncode != lineItem.variantID?.shopifyIDEncode })
        cartEnv.lineItem_OOS_isChanged = false
    }
}

//#Preview {
//    ShoppingCartOOSCell(lineItem: <#LineItemViewModel#>)
//        .environmentObject(CartEnvironment())
//}
