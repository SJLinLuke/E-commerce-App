//
//  CitySuper_Eshop_cloneApp.swift
//  CitySuper-Eshop clone
//
//  Created by LukeLin on 2024/5/9.
//

import SwiftUI

@main
struct CitySuper_Eshop_cloneApp: App {
    
    // init
    @State private var userEnv = UserEnviroment()
    @StateObject private var couponListVM = CouponListViewModel()
    
    var body: some Scene {
        WindowGroup {
            MainTabbarView()
                .environmentObject(userEnv)
        }
    }
}
