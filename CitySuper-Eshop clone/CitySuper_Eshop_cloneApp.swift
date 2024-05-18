//
//  CitySuper_Eshop_cloneApp.swift
//  CitySuper-Eshop clone
//
//  Created by LukeLin on 2024/5/9.
//

import SwiftUI

@main
struct CitySuper_Eshop_cloneApp: App {
    
    @State var userEnv = UserEnviroment()
    
    var body: some Scene {
        WindowGroup {
            MainTabbarView()
                .environmentObject(userEnv)
        }
    }
}
