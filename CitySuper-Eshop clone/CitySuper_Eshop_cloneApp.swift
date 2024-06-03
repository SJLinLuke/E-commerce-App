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
    @State private var isShowingIntroVideo: Bool = false
    
    @StateObject private var couponListVM = CouponListViewModel.shared
    @StateObject private var inboxVM      = InboxViewModel.shared
    private var networkManager            = NetworkManager.shared
    
    var body: some Scene {
        WindowGroup {
            MainTabbarView()
                .environmentObject(userEnv)
                .onAppear {
                    // init
                    couponListVM.fetchCoupon()
                    inboxVM.fetchUnreadNumber()
                    networkManager.userEnv = userEnv
                    
                    self.isShowingIntroVideo = true
                }
                .fullScreenCover(isPresented: $isShowingIntroVideo) {
                    AVPlayerView(isShowingIntoVideo: $isShowingIntroVideo)
                }
        }
    }
}
