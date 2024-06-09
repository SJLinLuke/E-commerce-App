//
//  ProfileListView.swift
//  CitySuper-Eshop clone
//
//  Created by LukeLin on 2024/5/15.
//

import SwiftUI

struct ProfileListView: View {
    
    @EnvironmentObject var userEnv: UserEnviroment
    @StateObject var VM = ProfileViewModel()
    
    @State var isShowingLoginView     : Bool = false
    @State var isShowingOrderHistory   : Bool = false
    @State var isShowingDeliveryAddress: Bool = false
    @State var isShowingMoreList       : Bool = false
    @State var isShowingCouponList     : Bool = false
    
    var body: some View {
        List(VM.getProfileData(), rowContent: { rowData in
            ProfileListCell(rowData: rowData)
                .onTapGesture {
                    tapCell(rowData)
                }
        })
        .onAppear{
            VM.userEnv = userEnv
        }
        .listStyle(.plain)
        .listSectionSeparator(.hidden, edges: .all)
        .environment(\.defaultMinListRowHeight, 55)
        .padding(.top, -3)
        .fullScreenCover(isPresented: $isShowingLoginView) {
            LoginView(isShow: $isShowingLoginView)
        }
        .navigationDestination(isPresented: $isShowingOrderHistory) {
            OrderHistoryView(selectIndex: .constant(1))
        }
        .navigationDestination(isPresented: $isShowingDeliveryAddress) {
            DeliveryAddressView()
        }
        .navigationDestination(isPresented: $isShowingMoreList) {
            MoreListView()
        }
        .navigationDestination(isPresented: $isShowingCouponList) {
            CouponListView(isRedeemable: false)
        }
    }
    
    func tapCell(_ rowData: ProfileRowModel) {
        DispatchQueue.main.async {
            switch rowData.title {
            case "E-Shop Coupon":
                isShowingCouponList.toggle()
            case "Order History":
                isShowingOrderHistory.toggle()
            case "Delivery Address":
                isShowingDeliveryAddress.toggle()
            case "Wallet":
                print(rowData.title)
            case "More":
                isShowingMoreList.toggle()
            case "Login":
                isShowingLoginView.toggle()
            case "Logout":
                userEnv.removeUser()
                OrderHistoryViewModel.shared.initHistorys()
                InboxViewModel.shared.initInboxMessages()
                FavouriteViewModel.shared.initFavourites()
            default:
                break
            }
            
        }
    }
}

#Preview {
    ProfileListView()
        .environmentObject(UserEnviroment())
}
