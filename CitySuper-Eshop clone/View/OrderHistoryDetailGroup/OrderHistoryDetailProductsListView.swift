//
//  OrderHistoryProductsView.swift
//  CitySuper-Eshop clone
//
//  Created by LukeLin on 2024/5/27.
//

import SwiftUI
import MobileBuySDK

struct OrderHistoryDetailProductsListView: View {
    
    let lineItems: [Storefront.OrderLineItem]
    
    var body: some View {
        LazyVGrid(columns: [GridItem()]){
            ForEach(lineItems.indices, id: \.self) { index in
                OrderHistoryProductsListCell(lineItem: lineItems[index])
            }
        }
    }
}

//#Preview {
//    OrderHistoryDetailProductsView()
//}
