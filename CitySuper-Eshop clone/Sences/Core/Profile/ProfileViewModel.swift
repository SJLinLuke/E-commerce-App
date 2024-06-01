//
//  ProfileViewModel.swift
//  CitySuper-Eshop clone
//
//  Created by LukeLin on 2024/5/15.
//

import Foundation
import SwiftUI

@MainActor final class ProfileViewModel: ObservableObject {
    
    @Published var userEnv  : UserEnviroment? = nil
    @Published var isLoading: Bool = false

    func getProfileData() -> [ProfileRowModel] {
        return userEnv?.isLogin ?? false ?
        [
          ProfileRowModel(title: "E-Shop Coupon", icon: "coupon_icon", seperateType: true),
          ProfileRowModel(title: "Order History", icon: "tab_history", seperateType: true),
          ProfileRowModel(title: "Delivery Address", icon: "address_icon", seperateType: true),
          ProfileRowModel(title: "Wallet", icon: "wallet_icon", seperateType: true),
          ProfileRowModel(title: "More", icon: "more_icon", seperateType: true),
          ProfileRowModel(title: "Logout", icon: "", seperateType: false)
        ]
        :
        [ 
          ProfileRowModel(title: "More", icon: "more_icon", seperateType: true),
          ProfileRowModel(title: "Login", icon: "", seperateType: false)
        ]
        
        
    }
}
