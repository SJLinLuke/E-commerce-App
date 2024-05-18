//
//  OrderView.swift
//  CitySuper-Eshop clone
//
//  Created by LukeLin on 2024/5/9.
//

import SwiftUI

struct OrderHistoryView: View {
    
    @EnvironmentObject var userEnv: UserEnviroment
    
    @Binding var selectIndex: Int
    
    @State var isShowingLoginModal: Bool = false
    
    var body: some View {
        NavigationStack {
            Text("OrderHistoryView!")
        }
//        .overlay {
//            if(VM.isLoading) {
//                LoadingIndicatiorView()
//            }
//        }
        .onAppear {
            DispatchQueue.main.async {
                self.isShowingLoginModal = !userEnv.isLogin
            }
        }
        .fullScreenCover(isPresented: $isShowingLoginModal, onDismiss: {
            if !userEnv.isLogin {
                selectIndex = 4
            }
        }, content: {
            LoginView(isShowingModal: $isShowingLoginModal)
        })
        
    }
}

#Preview {
    OrderHistoryView(selectIndex: .constant(1))
        .environmentObject(UserEnviroment())
}
