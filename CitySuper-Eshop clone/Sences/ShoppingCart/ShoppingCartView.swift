//
//  ShoppingCartView.swift
//  CitySuper-Eshop clone
//
//  Created by LukeLin on 2024/5/18.
//

import SwiftUI

struct ShoppingCartView: View {
    
    @EnvironmentObject private var userEnv: UserEnviroment
    @EnvironmentObject private var cartEnv: CartEnvironment
    
    @Binding var isShowingModal: Bool
    
    var body: some View {
        NavigationStack {
            ZStack {
                Color(hex:"F2F2F2")
                if cartEnv.lineItems.isEmpty {
                    ShoppingCartEmptyView()
                        .overlay(alignment: .top) {
                            ShoppingCartOOSView(lineItems_OOS: cartEnv.lineItems_OOS)
                        }
                } else {
                    VStack {
                        
                        if !cartEnv.noticeMessage.isEmpty {
                            ShoppingCartNoticeView(noticeMessage: cartEnv.noticeMessage)
                        }
                        
                        ShoppingCartOOSView(lineItems_OOS: cartEnv.lineItems_OOS)
                                                
                        ShoppingCartHeaderView(cartItemsNum: cartEnv.cartItemsCountingNum)
                        
                        ScrollView {
                            LazyVGrid(columns: [GridItem()], spacing: 1) {
                                ForEach(cartEnv.lineItems) { lineItem in
                                    ShoppingCartProductsListCell(lineItem: lineItem)
                                }
                            }
                        }
                        .padding(.top, -8)
                        .padding(.bottom, -8)
                        
                        ShoppingCartInfoView()
                    }
                }
            }
            .overlay {
                if cartEnv.isLoading {
                    LoadingIndicatiorView()
                }
            }
            .task {
                if userEnv.isLogin {
                    cartEnv.fetchCheckout()
                }
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
            .navigationDestination(isPresented: $cartEnv.isShowCheckout) {
                CheckoutMethodsParentsView()
            }
        }
    }
}

#Preview {
    ShoppingCartView(isShowingModal: .constant(true))
        .environmentObject(UserEnviroment())
        .environmentObject(CartEnvironment())
}
