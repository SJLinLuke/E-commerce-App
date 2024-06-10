//
//  ShoppingCartProductsListCell.swift
//  CitySuper-Eshop clone
//
//  Created by LukeLin on 2024/6/11.
//

import SwiftUI

struct ShoppingCartProductsListCell: View {
    
    @EnvironmentObject private var cartEnv: CartEnvironment
    
    @State var quantity: Int
    
    let lineItem: LineItemViewModel
    
    init(lineItem: LineItemViewModel) {
        self.lineItem = lineItem
        self.quantity = lineItem.quantity
    }
    
    var body: some View {
        
        HStack {
            RemoteImageView(url: lineItem.variant?.image?.url.absoluteString ?? "", placeholder: .common)
                .frame(width: 130, height: 130)
            
            VStack(alignment: .leading) {
                Text(lineItem.title)
                    .fontWeight(.bold)
                    .lineLimit(2)
                
                if !cartEnv.getLogicTag(shopifyID: lineItem.variantID?.shopifyIDEncode ?? "").isEmpty {
                    BulletPointsView(tags: cartEnv.getLogicTag(shopifyID: lineItem.variantID?.shopifyIDEncode ?? ""), mode: .cart)
                }
                    
                Spacer()
                
                QuantitySelectorView(quantity: $quantity, inventoryQuantity: Int(lineItem.variant?.quantityAvailable ?? 0))
            }
            
            Spacer()
            
            VStack(alignment: .trailing) {
                let isCompareWithPrice = lineItem.variant?.compareAtPrice?.amount ?? 0.0 != 0.0
                
                Text(Currency.stringFrom(lineItem.individualPrice))
                    .foregroundColor(isCompareWithPrice ? Color(hex: "E85321") : .black)
                
                if isCompareWithPrice {
                    Text(Currency.stringFrom(lineItem.variant?.compareAtPrice?.amount ?? 0))
                        .font(.caption)
                        .foregroundColor(.secondary)
                        .strikethrough()
                }
                
                Spacer()
                
                Button {
                    
                } label: {
                    Image("trash_can_icon")
                }
            }
            .padding(.trailing, 5)
            .padding(.leading)
        }
        .font(.subheadline)
        .padding(8)
        .background(.white)
        .padding(.horizontal, 10)
    }
}

//#Preview {
//    ShoppingCartProductsListCell()
//        .environmentObject(CartEnvironment())
//}
