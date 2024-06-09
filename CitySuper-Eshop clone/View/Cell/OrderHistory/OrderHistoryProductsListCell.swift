//
//  ProductsListCell.swift
//  CitySuper-Eshop clone
//
//  Created by LukeLin on 2024/6/9.
//

import SwiftUI
import MobileBuySDK

struct OrderHistoryProductsListCell: View {
    
    let lineItem: Storefront.OrderLineItem
    
    var body: some View {
        HStack(spacing: 8) {
            RemoteImageView(url: lineItem.variant?.image?.url.absoluteString ?? "",
                            placeholder: .common)
                .frame(width: 130, height: 130)
            
            VStack(alignment: .leading) {
                Text(lineItem.title)
                    .fontWeight(.bold)
                    .lineLimit(3)
                
                Text("QTY: \(lineItem.quantity)")
                    .font(.subheadline)
                    .padding(.top, 2)
                
                Spacer()
                
                HStack {
                    Spacer()
                    
                    Text(Currency.stringFrom(lineItem.originalTotalPrice.amount))
                        .foregroundColor(Color(hex: "E85321"))
                }
            }
            .font(.subheadline)
        }
    }
}

//#Preview {
//    ProductsListCell(lineItem: )
//}
