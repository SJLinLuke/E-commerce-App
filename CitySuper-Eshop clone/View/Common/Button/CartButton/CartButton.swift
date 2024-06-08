//
//  CartButton.swift
//  CitySuper-Eshop clone
//
//  Created by LukeLin on 2024/5/21.
//

import SwiftUI

struct CartButton: View {
    
    @EnvironmentObject private var cartEnv: CartEnvironment
    
    var width: CGFloat
    var height: CGFloat
    
    init(width: CGFloat, height: CGFloat) {
        self.width = width
        self.height = height
    }
    
    var body: some View {
        Button {
            cartEnv.isShowCartButtonSheet.toggle()
        } label: {
            Image("cart_icon")
                .resizable()
                .frame(width: width, height: height)
        }
    }
}

#Preview {
    CartButton(width: 25, height: 25)
}
