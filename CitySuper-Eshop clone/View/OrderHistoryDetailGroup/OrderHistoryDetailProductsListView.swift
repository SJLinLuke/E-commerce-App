//
//  OrderHistoryProductsView.swift
//  CitySuper-Eshop clone
//
//  Created by LukeLin on 2024/5/27.
//

import SwiftUI
import MobileBuySDK

struct OrderHistoryDetailProductsListView: View {
    
    var lineItems_order: [Storefront.OrderLineItem]?
    var lineItems_cart : [LineItemViewModel]?
    
    var body: some View {
        LazyVGrid(columns: [GridItem()]){
            if let lineItems = lineItems_order {
                ForEach(lineItems.indices, id: \.self) { index in
                    OrderHistoryProductsListCell(lineItem_order: lineItems[index])
                }
            }
            
            if let lineItems = lineItems_cart {
                ForEach(lineItems.indices, id: \.self) { index in
                    OrderHistoryProductsListCell(lineItem_cart: lineItems[index])
                }
            }
            
        }
    }
}

//#Preview {
//    OrderHistoryDetailProductsView()
//}
