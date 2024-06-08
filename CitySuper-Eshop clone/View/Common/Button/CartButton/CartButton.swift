//
//  CartButton.swift
//  CitySuper-Eshop clone
//
//  Created by LukeLin on 2024/5/21.
//

import SwiftUI

struct CartButton: View {
    
    @StateObject private var addToCartVM = AddToCartButtomSheetViewModel.shared
    
    var width: CGFloat
    var height: CGFloat
    
    let shopifyID: String
    
    init(width: CGFloat, height: CGFloat, shopifyID: String) {
        self.width     = width
        self.height    = height
        self.shopifyID = shopifyID
    }
    
    var body: some View {
        Button {
            addToCartVM.isProductSoldOut(shopifyID: shopifyID) { isSoldOut in
                if (isSoldOut) {
                    addToCartVM.alertItem = AlertContext.outOfStock
                } else {
                    addToCartVM.isShowAddToCartButtonSheet.toggle()
                }
            }
            
            
        } label: {
            Image("cart_icon")
                .resizable()
                .frame(width: width, height: height)
        }
    }
}

#Preview {
    CartButton(width: 25, height: 25, shopifyID: "")
}
