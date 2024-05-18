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
    
    @State var isShowingModal: Bool = false
    
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
        .fullScreenCover(isPresented: $isShowingModal) {
            LoginView(isShowingModal: $isShowingModal)
        }
    }
    
    func tapCell(_ rowData: ProfileRowModel) {
        switch rowData.title {
            case "E-Shop Coupon":
                print(rowData.title)
            case "Order History":
                print(rowData.title)
            case "Delivery Address":
                print(rowData.title)
            case "Wallet":
                print(rowData.title)
            case "More":
                print(rowData.title)
            case "Login":
                DispatchQueue.main.async {
                    isShowingModal.toggle()
                }
            case "Logout":
                print(rowData.title)
                userEnv.removeUser()
            default:
                break
        }
    }
}

#Preview {
    ProfileListView()
        .environmentObject(UserEnviroment())
}
