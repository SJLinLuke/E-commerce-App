//
//  NavigationModifier.swift
//  CitySuper-Eshop clone
//
//  Created by LukeLin on 2024/5/18.
//

import SwiftUI

struct NavigationModifier: ViewModifier {
        
    @State var isPushToCollectionsList: Bool = false
    @State var isShowingShoppingCart  : Bool = false
    
    var title: String?
    var isHideCollectionsList: Bool = false
    var isHideShoppingCart: Bool = false
    
    func body(content: Content) -> some View {
        content
            .navigationBarTitleDisplayMode(.inline)
            .navigationTitle((title != nil ? title : nil) ?? "")
            .toolbar {
                if title == nil || title?.isEmpty ?? true {
                    ToolbarItem(placement: .principal) {
                        Image("bar_logo")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 110, height: 100)
                    }
                }
               
                if !isHideCollectionsList {
                    ToolbarItem(placement: .navigationBarLeading) {
                        Button {
                            isPushToCollectionsList.toggle()
                        } label: {
                            Image("bar_category_icon")
                        }
                    }
                }
                
                if !isHideShoppingCart {
                    ToolbarItem(placement: .navigationBarTrailing) {
                        Button {
                            isShowingShoppingCart.toggle()
                        } label: {
                            Image("bar_shoppingcart_icon")
                        }
                    }
                }
            }
            .navigationDestination(isPresented: $isPushToCollectionsList) {
                MoreCollectionsListView()
            }
            .fullScreenCover(isPresented: $isShowingShoppingCart) {
                ShoppingCartView(isShowingModal: $isShowingShoppingCart)
            }
    }
    
}
