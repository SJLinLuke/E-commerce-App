//
//  ContentView.swift
//  CitySuper-Eshop clone
//
//  Created by LukeLin on 2024/5/9.
//

import SwiftUI
import UIKit

struct MainTabbarView: View {
    
    @EnvironmentObject private var userEnv: UserEnviroment
    
    @StateObject private var inboxVM     = InboxViewModel.shared
    @StateObject private var addToCartVM = AddToCartButtomSheetViewModel.shared
    
    @State private var selectIndex: Int = 0
    var body: some View {
        TabView(selection: $selectIndex) {
            
            HomeView()
                .tabItem { Label("Home",
                                 image: selectIndex == 0 ? "tab_home_on" : "tab_home")}
                .tag(0)
            
            OrderHistoryView(selectIndex: $selectIndex)
                .tabItem { Label("Order History",
                                 image: selectIndex == 1 ? "tab_history_on" : "tab_history")}
                .tag(1)
            
            InboxView(selectIndex: $selectIndex)
                .tabItem { Label("Inbox",
                                 image: selectIndex == 2 ? "tab_inbox_on" : "tab_inbox")}
                .tag(2)
                .badge(inboxVM.unreadNumber)
            
            FavouritesView()
                .tabItem { Label("Favourite",
                                 image: selectIndex == 3 ? "tab_favourites_on" : "tab_favourites")}
                .tag(3)
                
            
            ProfileView()
                .tabItem { Label("Profile", 
                                 image: selectIndex == 4 ? "tab_profile_on" : "tab_profile")}
                .tag(4)
        }
        .tint(Color(.themeGreen))
        .onChange(of: selectIndex) {
            if (userEnv.isLogin) {
                inboxVM.fetchUnreadNumber()
            }
        }
        .overlay {
            if addToCartVM.isLoading {
                LoadingIndicatiorView()
            }
        }
        .sheet(isPresented: $addToCartVM.isShowAddToCartButtonSheet) {
            if userEnv.isLogin {
                AddToCartButtomSheet()
            } else {
                LoginView(isShow: $addToCartVM.isShowAddToCartButtonSheet)
                    .interactiveDismissDisabled()
            }
        }
        .modifier(PopupViewModifier())
    }

    init() {
        UITabBar.appearance().backgroundColor = UIColor.white
    }
}

#Preview {
    MainTabbarView()
        .environmentObject(UserEnviroment())
        .environmentObject(CartEnvironment())
}
