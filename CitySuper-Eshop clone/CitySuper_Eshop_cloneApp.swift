//
//  CitySuper_Eshop_cloneApp.swift
//  CitySuper-Eshop clone
//
//  Created by LukeLin on 2024/5/9.
//

import SwiftUI
import Stripe

@main
struct CitySuper_Eshop_cloneApp: App {
    
    @Environment(\.scenePhase) private var scenePhase
    
    @AppStorage("hasLaunchedBefore") private var hasLaunchedBefore = false
    
    @State private var userEnv = UserEnviroment()
    @State private var cartEnv = CartEnvironment()
    @State private var isShowIntroVideo: Bool = false
    @State private var isShowTutorial  : Bool = false
    
    @StateObject private var FavVM        = FavouriteViewModel.shared
    @StateObject private var couponListVM = CouponListViewModel.shared
    @StateObject private var inboxVM      = InboxViewModel.shared
    @StateObject private var alertManager = AlertManager.shared

    private var networkManager = NetworkManager.shared
    private var stripeManager  = StripeManager.shared
    
    var body: some Scene {
        WindowGroup {
            MainTabbarView()
                .environmentObject(userEnv)
                .environmentObject(cartEnv)
                .task {
                    // init
                    networkManager.userEnv = userEnv
                    cartEnv.userEnv = userEnv
                    stripeManager.userEnv = userEnv
                    
                    if userEnv.isLogin {
                        FavVM.fetchFavourite()
                        cartEnv.fetchCheckout(needAsync: false)
                        couponListVM.fetchCoupon()
                        inboxVM.fetchUnreadNumber()
                    }
                    
                    if !hasLaunchedBefore {
                        DispatchQueue.main.async {
                            isShowIntroVideo = true
                        }
                    }
                    
                    StripeAPI.defaultPublishableKey = Constants.stripe_apiKey
                }
                .fullScreenCover(isPresented: $isShowIntroVideo) {
                    AVPlayerView(isShowIntoVideo: $isShowIntroVideo, isShowTutorial: $isShowTutorial)
                }
                .fullScreenCover(isPresented: $isShowTutorial) {
                    TurorialView(isShow: $isShowTutorial)
                }
                .modifier(AlertModifier(alertItem: alertManager.alertItem, isAlertShow: $alertManager.isShowAlert))
        }
        .onChange(of: scenePhase) { newPhase in
            if newPhase == .active && !hasLaunchedBefore {
                hasLaunchedBefore = true
            } else {
                hasLaunchedBefore = false
            }
        }
    }
}
