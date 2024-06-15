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

    func getProfileData() -> [CustomListRowModel] {
        return userEnv?.isLogin ?? false ?
        [
          CustomListRowModel(title: "E-Shop Coupon", icon: "coupon_icon", seperateType: true),
          CustomListRowModel(title: "Order History", icon: "tab_history", seperateType: true),
          CustomListRowModel(title: "Delivery Address", icon: "address_icon", seperateType: true),
          CustomListRowModel(title: "Wallet", icon: "wallet_icon", seperateType: true),
          CustomListRowModel(title: "More", icon: "more_icon", seperateType: true),
          CustomListRowModel(title: "Logout", icon: "", seperateType: false)
        ]
        :
        [ 
          CustomListRowModel(title: "More", icon: "more_icon", seperateType: true),
          CustomListRowModel(title: "Login", icon: "", seperateType: false)
        ]
        
        
    }
}
