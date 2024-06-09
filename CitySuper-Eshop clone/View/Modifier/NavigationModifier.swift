//
//  NavigationModifier.swift
//  CitySuper-Eshop clone
//
//  Created by LukeLin on 2024/5/18.
//

import SwiftUI

struct NavigationModifier: ViewModifier {
    
    @EnvironmentObject private var cartEnv: CartEnvironment
        
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
                        .overlay(alignment: .topTrailing) { 
                            // native badge is not allow in ToolbarItem, custom one for now
                            let width = cartEnv.cartItemsCountingNum > 10 ? 20.0 : 15.0
                            Text("\(cartEnv.cartItemsCountingNum)")
                                .font(.system(size: 12))
                                .foregroundColor(.white)
                                .frame(width: width, height: 15)
                                .background(Color(hex: "E94E1B"))
                                .cornerRadius(50)
                                .alignmentGuide(.top) { $0[.bottom] - $0.width * 0.8}
                                .alignmentGuide(.trailing) { $0[.trailing] - $0.width * 0.5 }
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
