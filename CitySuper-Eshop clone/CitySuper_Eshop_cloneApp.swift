//
//  CitySuper_Eshop_cloneApp.swift
//  CitySuper-Eshop clone
//
//  Created by LukeLin on 2024/5/9.
//

import SwiftUI

@main
struct CitySuper_Eshop_cloneApp: App {
    
    @State private var userEnv = UserEnviroment()
    @State private var cartEnv = CartEnvironment()
    @State private var isShowingIntroVideo: Bool = false
    
    @StateObject private var FavVM        = FavouriteViewModel.shared
    @StateObject private var couponListVM = CouponListViewModel.shared
    @StateObject private var inboxVM      = InboxViewModel.shared
    
    private var networkManager            = NetworkManager.shared
    
    var body: some Scene {
        WindowGroup {
            MainTabbarView()
                .environmentObject(userEnv)
                .environmentObject(cartEnv)
                .onAppear {
                    // init
                    networkManager.userEnv = userEnv
                    cartEnv.userEnv = userEnv
                    
                    if userEnv.isLogin {
                        FavVM.fetchFavourite()
                        cartEnv.fetchCheckout(needAsync: false)
                        couponListVM.fetchCoupon()
                        inboxVM.fetchUnreadNumber()
                    }
                    
                    DispatchQueue.main.async {
                        self.isShowingIntroVideo = true
                    }
                }
                .fullScreenCover(isPresented: $isShowingIntroVideo) {
                    AVPlayerView(isShowingIntoVideo: $isShowingIntroVideo)
                }
        }
    }
}
