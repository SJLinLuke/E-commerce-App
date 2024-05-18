//
//  ProfileListCell.swift
//  CitySuper-Eshop clone
//
//  Created by LukeLin on 2024/5/15.
//

import SwiftUI

struct ProfileListCell: View {
    
    let rowData: ProfileRowModel
    @State var isLoginOrLogout: Bool = false
    
    var body: some View {
        VStack {
            HStack {
                Text(rowData.title)
                    .foregroundColor(isLoginOrLogout ? .themeGreen : .black
                    )
                Spacer()
                
                if (!rowData.icon.isEmpty) {
                    Image(rowData.icon)
                }
            }
        }
        .listRowSeparator(rowData.seperatType ? .automatic : .hidden)
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
    ProfileListCell(rowData: ProfileRowModel(title: "Test", icon: "coupon_icon", seperatType: true))
}
