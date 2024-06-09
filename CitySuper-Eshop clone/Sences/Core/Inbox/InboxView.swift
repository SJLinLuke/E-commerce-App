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
                            ForEach(VM.inBoxMessages, id: \.self) { inboxMessage in
                                NavigationLink { InboxDetailView(notificationID: inboxMessage.id) } label: {
                                    InboxListCell(message: inboxMessage)
                                        .onAppear {
                                            if (VM.inBoxMessages.last == inboxMessage && VM.isHasMore) {
                                                VM.fetchInbox()
                                            }
                                        }
                                }
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
        .fullScreenCover(isPresented: $isShowingLoginModal, onDismiss: {
            if !userEnv.isLogin {
                selectIndex = 4
            } else {
                VM.fetchInbox()
            }
        }, content: {
            LoginView(isShow: $isShowingLoginModal)
        })
    }
}

#Preview {
    InboxView(selectIndex: .constant(2))
        .environmentObject(UserEnviroment())
}
