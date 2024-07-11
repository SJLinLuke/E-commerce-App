//
//  NavigationModifier.swift
//  CitySuper-Eshop clone
//
//  Created by LukeLin on 2024/5/18.
//

import SwiftUI

struct NavigationModifier: ViewModifier {
    
    @EnvironmentObject private var cartEnv: CartEnvironment
    @EnvironmentObject private var userEnv: UserEnviroment
    
    @StateObject private var forgetPW_VM = ForgetPasswordViewModel.shared
    
    @State var isPushToCollectionsList: Bool = false
    @State var isShowingShoppingCart  : Bool = false
    @State var isShowingLoginView     : Bool = false
    
    var navTilte             : String?
    var isHideCollectionsList: Bool = false
    var isHideShoppingCart   : Bool = false
    
    func body(content: Content) -> some View {
        content
            .navigationBarTitleDisplayMode(.inline)
            .navigationTitle((navTilte != nil ? navTilte : nil) ?? "")
            .toolbar {
                if navTilte == nil || navTilte?.isEmpty ?? true {
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
                            if userEnv.isLogin {
                                isShowingShoppingCart.toggle()
                            } else {
                                isShowingLoginView.toggle()
                            }
                        } label: {
                            Image("bar_shoppingcart_icon")
                        }
                        .overlay(alignment: .topTrailing) { 
                            // native badge is not allow in ToolbarItem, custom one for now
                            let width = cartEnv.cartItemsCountingNum > 10 ? 20.0 : 16.0
                            Text("\(cartEnv.cartItemsCountingNum)")
                                .font(.system(size: 12))
                                .foregroundColor(.white)
                                .frame(width: width, height: 16) // expand the badge a little bit when count number is up to 10 or more
                                .background(Color(hex: "E94E1B"))
                                .cornerRadius(50)
                                .alignmentGuide(.top) { $0[.bottom] - $0.width * 0.8 }
                                .alignmentGuide(.trailing) { $0[.trailing] - $0.width * 0.5 }
                                .opacity(cartEnv.cartItemsCountingNum == 0 ? 0 : 1) // hide badge when count number is 0
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
            .fullScreenCover(isPresented: $isShowingLoginView) {
                LoginView(isShow: $isShowingLoginView)
            }
            .fullScreenCover(isPresented: $forgetPW_VM.isShowForgetPassword) {
                ForgetPasswordView(isShow: $forgetPW_VM.isShowForgetPassword)
            }
            .fullScreenCover(isPresented: $forgetPW_VM.isShowVerify) {
                VerifyView(isShow: $forgetPW_VM.isShowVerify)
            }
            .fullScreenCover(isPresented: $forgetPW_VM.isChangePassword) {
                ChangePasswordView(isShow: $forgetPW_VM.isChangePassword, OldPassword: userEnv.currentPassword)
            }
    }
}
