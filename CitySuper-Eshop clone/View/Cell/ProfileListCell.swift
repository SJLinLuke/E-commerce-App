//
//  ProfileListCell.swift
//  CitySuper-Eshop clone
//
//  Created by LukeLin on 2024/5/15.
//

import SwiftUI

struct ProfileListCell: View {
    
    @StateObject var couponListVM = CouponListViewModel.shared
    
    @State var isLoginOrLogout: Bool = false
    
    let rowData: ProfileRowModel
    
    var body: some View {
        VStack(alignment: .leading) {
            HStack {
                Text(rowData.title)
                    .foregroundColor(isLoginOrLogout ? .themeGreen : .black
                    )
                
                if (rowData.title == "E-Shop Coupon" && couponListVM.couponsCount > 0) {
                    Circle()
                        .frame(width: 30)
                        .foregroundColor(.themeDarkGreen)
                        .overlay {
                            Text("\(couponListVM.couponsCount)")
                                .foregroundColor(.white)
                        }
                }
                
                Spacer()
                
                if (!rowData.icon.isEmpty) {
                    Image(rowData.icon)
                }
            }
        }
        .listRowSeparator(rowData.seperateType ? .automatic : .hidden)
        .padding(.top, isLoginOrLogout ? 25 : 0)
        .overlay(alignment: .top) {
            if isLoginOrLogout {
                RoundedRectangle(cornerRadius: 0)
                    .fill(Color(hex: "F7F7F7"))
                    .frame(width: 400, height: 12)
            }
        }
        .onAppear {
            isLoginOrLogout = rowData.title == "Logout" || rowData.title == "Login"
        }
        .contentShape(Rectangle())
    }
}

#Preview {
    ProfileListCell(rowData: ProfileRowModel(title: "E-Shop Coupon", icon: "coupon_icon", seperateType: true))
}
