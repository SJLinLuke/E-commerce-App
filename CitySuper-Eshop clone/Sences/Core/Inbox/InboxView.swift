//
//  InboxView.swift
//  CitySuper-Eshop clone
//
//  Created by LukeLin on 2024/5/9.
//

import SwiftUI

struct InboxView: View {
    
    @EnvironmentObject var userEnv: UserEnviroment
    
    @StateObject var VM = InboxViewModel.shared
    
    @Binding var selectIndex: Int
    
    @State var isShowingLoginModal: Bool = false
    
    var body: some View {
        NavigationStack {
            VStack {
                if (VM.inBoxMessages.isEmpty) {
                    InboxEmptyView()
                } else {
                    ScrollView {
                        LazyVGrid(columns: [GridItem()], alignment: .leading) {
                            ForEach(VM.inBoxMessages.indices, id: \.self) { index in
                                NavigationLink { InboxDetailView(notificationID: VM.inBoxMessages[index].id) } label: {
                                    InboxListCell(message: VM.inBoxMessages[index])
                                        .onAppear {
                                            if (VM.inBoxMessages.last == VM.inBoxMessages[index] && VM.isHasMore) {
                                                VM.fetchInbox()
                                            }
                                        }
                                }
                                .simultaneousGesture(TapGesture().onEnded{
                                    VM.inBoxMessages[index].read = true
                                    VM.unreadNumber -= 1
                                })
                                SeperateLineView()
                            }
                        }
                    }
                }
            }
            .navigationTitle("Inbox")
            .navigationBarTitleDisplayMode(.inline)
        }
        .overlay {
            if VM.isLoading {
                LoadingIndicatiorView()
            }
        }
        .task {
            if userEnv.isLogin && VM.inBoxMessages.isEmpty {
                VM.fetchInbox()
            }
        }
        .onAppear {
            DispatchQueue.main.async {
                self.isShowingLoginModal = !userEnv.isLogin
            }
        }
//        .fullScreenCover(isPresented: $isShowingLoginModal, onDismiss: {
//            if !userEnv.isLogin {
//                selectIndex = 4
//            } else {
//                VM.fetchInbox()
//            }
//        }, content: {
//            LoginView(isShowingModal: $isShowingLoginModal)
//        })
    }
}

#Preview {
    InboxView(selectIndex: .constant(2))
        .environmentObject(UserEnviroment())
}
