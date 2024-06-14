//
//  ShoppingCartOOSView.swift
//  CitySuper-Eshop clone
//
//  Created by LukeLin on 2024/6/15.
//

import SwiftUI

struct ShoppingCartOOSView: View {
    
    let lineItems_OOS: [LineItemViewModel]
    
    var body: some View {
        LazyVGrid(columns: [GridItem()], spacing: 2) {
            ForEach(lineItems_OOS) { lineItem_OOS in
                ShoppingCartOOSCell(lineItem: lineItem_OOS)
            }
        }
    }
}
//
//#Preview {
//    ShoppingCartOOSView()
//}
