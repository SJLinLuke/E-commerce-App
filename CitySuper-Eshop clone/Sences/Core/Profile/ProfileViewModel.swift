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

    func getProfileData() -> [CommonListRowModel] {
        return userEnv?.isLogin ?? false ?
        [
          CommonListRowModel(title: "E-Shop Coupon", icon: "coupon_icon", seperateType: true),
          CommonListRowModel(title: "Order History", icon: "tab_history", seperateType: true),
          CommonListRowModel(title: "Delivery Address", icon: "address_icon", seperateType: true),
          CommonListRowModel(title: "Wallet", icon: "wallet_icon", seperateType: true),
          CommonListRowModel(title: "More", icon: "more_icon", seperateType: true),
          CommonListRowModel(title: "Logout", icon: "", seperateType: false)
        ]
        :
        [ 
          CommonListRowModel(title: "More", icon: "more_icon", seperateType: true),
          CommonListRowModel(title: "Login", icon: "", seperateType: false)
        ]
        
        
    }
}
