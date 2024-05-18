//
//  ProfileView.swift
//  CitySuper-Eshop clone
//
//  Created by LukeLin on 2024/5/9.
//

import SwiftUI

struct ProfileView: View {
    
    @EnvironmentObject var userEnv: UserEnviroment

    var body: some View {
        NavigationStack {
            VStack {
                if userEnv.isLogin {
                    ProfileInfoView()
                        .frame(height: 240)
                }
                
                ProfileListView()
                
                Spacer()
            }
            .navigationTitle("Profile")
            .navigationBarTitleDisplayMode(.inline)
        }
    }
}

#Preview {
    ProfileView()
        .environmentObject(UserEnviroment())
}


