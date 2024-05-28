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
    
    @State var isShowingLoginModal     : Bool = false
    @State var isShowingOrderHistory   : Bool = false
    @State var isShowingDeliveryAddress: Bool = false
    
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
        .fullScreenCover(isPresented: $isShowingLoginModal) {
            LoginView(isShowingModal: $isShowingLoginModal)
        }
        .navigationDestination(isPresented: $isShowingOrderHistory) {
            OrderHistoryView(selectIndex: .constant(1))
        }
        .navigationDestination(isPresented: $isShowingDeliveryAddress) {
            DeliveryAddressView()
        }
    }
    
    func tapCell(_ rowData: ProfileRowModel) {
        DispatchQueue.main.async {
            switch rowData.title {
            case "E-Shop Coupon":
                print(rowData.title)
            case "Order History":
                isShowingOrderHistory.toggle()
            case "Delivery Address":
                isShowingDeliveryAddress.toggle()
            case "Wallet":
                print(rowData.title)
            case "More":
                print(rowData.title)
            case "Login":
                isShowingLoginModal.toggle()
            case "Logout":
                print(rowData.title)
                userEnv.removeUser()
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
