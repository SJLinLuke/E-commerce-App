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

    @StateObject var VM = OrderHistoryViewModel.shared
    
    var body: some View {
        NavigationStack {
            VStack {
                
                SearchBarView()
                
                List(VM.orderHistorys) { orderHistory in
                    OrderHistoryCell(orderHistory: orderHistory)
                        .onAppear {
                            if VM.orderHistorys.last == orderHistory {
                                VM.fetchOrder()
                            }
                        }
                }
                
                .listStyle(.plain)
                .padding(.top, -8)
                
                Spacer()
            }
            .navigationTitle("Order History")
            .navigationBarTitleDisplayMode(.inline)
        }
        .overlay {
            if VM.isLoading {
                LoadingIndicatiorView()
            }
        }
        .onAppear {
            DispatchQueue.main.async {
                self.isShowingLoginModal = !userEnv.isLogin
                self.VM.userEnv = userEnv
            }
        }
        .task {
            if userEnv.isLogin {
                VM.fetchOrder()
            }
        }
//        .fullScreenCover(isPresented: $isShowingLoginModal, onDismiss: {
//            if !userEnv.isLogin {
//                selectIndex = 4
//            }
//            VM.fetchOrder()
//        }, content: {
//            LoginView(isShowingModal: $isShowingLoginModal)
//        })
        
    }
}

#Preview {
    OrderHistoryView(selectIndex: .constant(1))
        .environmentObject(UserEnviroment())
}


struct SearchBarView: View {
    
    @State var searchText: String = ""
    @State var isSorting : Bool = false
    
    var body: some View {
        HStack {
            Image("search_icon")
                .padding(.trailing, 10)
            
            TextField("Order History", text: $searchText)
                .font(.callout)
            
            Rectangle()
                .frame(width: 1, height: 25)
            
            Button {
                isSorting.toggle()
            } label: {
                Image("sort_icon")
            }
            
        }
        .padding(EdgeInsets(top: 0, leading: 10, bottom: 10, trailing: 10))
        .overlay(alignment: .bottom) {
            RoundedRectangle(cornerRadius: 0)
                .fill(Color(hex: "E2E2E2"))
                .frame(height: 1)
        }
    }
}
