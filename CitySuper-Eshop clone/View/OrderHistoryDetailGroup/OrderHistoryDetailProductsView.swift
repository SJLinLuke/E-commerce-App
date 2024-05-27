//
//  OrderHistoryProductsView.swift
//  CitySuper-Eshop clone
//
//  Created by LukeLin on 2024/5/27.
//

import SwiftUI
import MobileBuySDK

struct OrderHistoryDetailProductsView: View {
    
    let lineItems: [Storefront.OrderLineItem]
    
    var body: some View {
        LazyVGrid(columns: [GridItem()]){
            ForEach(lineItems.indices, id: \.self) { index in
                HStack(spacing: 8) {
                    RemoteImageView(url: lineItems[index].variant?.image?.url.absoluteString ?? "",
                                    placeholder: .common)
                        .frame(width: 130, height: 130)
                    
                    VStack(alignment: .leading) {
                        Text(lineItems[index].title)
                            .fontWeight(.bold)
                            .lineLimit(3)
                        
                        Text("QTY: \(lineItems[index].quantity)")
                            .font(.subheadline)
                            .padding(.top, 2)
                        
                        Spacer()
                        
                        HStack {
                            Spacer()
                            
                            Text("$\(lineItems[index].originalTotalPrice.amount.formattedPrice)")
                                .foregroundColor(Color(hex: "E85321"))
                        }
                    }
                    .font(.subheadline)
                }
            }
        }
    }
}

//#Preview {
//    OrderHistoryDetailProductsView()
//}
