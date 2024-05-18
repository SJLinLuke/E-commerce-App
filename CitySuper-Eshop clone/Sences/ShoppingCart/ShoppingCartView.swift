//
//  ShoppingCartView.swift
//  CitySuper-Eshop clone
//
//  Created by LukeLin on 2024/5/18.
//

import SwiftUI

struct ShoppingCartView: View {
    
    @Binding var isShowingModal: Bool
    
    var body: some View {
        NavigationStack {
            ZStack {
                Color(hex:"F2F2F2")
            }
            .navigationTitle("Shopping Cart")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button {
                        isShowingModal = false
                    } label: {
                        Image("back_icon")
                    }
                }
            }
            
        }
    }
}

#Preview {
    ShoppingCartView(isShowingModal: .constant(true))
}
