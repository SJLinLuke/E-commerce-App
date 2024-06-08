//
//  OrderView.swift
//  CitySuper-Eshop clone
//
//  Created by LukeLin on 2024/5/9.
//

import SwiftUI

struct OrderHistoryView: View {
    
    @EnvironmentObject var userEnv: UserEnviroment
    
    @StateObject var VM = OrderHistoryViewModel.shared
    
    @State var searchText         : String = ""
    @State var currentSortKey     : String = "ALL"
    @State var isShowingLoginModal: Bool = false

    @Binding var selectIndex: Int
    
    var body: some View {
        NavigationStack {
            VStack {
                SearchBarView(currentSortKey: $currentSortKey, 
                              searchText: $searchText)
                
                if VM.getHistorys(searchText, sort: currentSortKey).isEmpty {
                    OrderHistoryEmptyView()
                } else {
                    ScrollView {
                        LazyVGrid(columns: [GridItem()]) {
                            ForEach(VM.getHistorys(searchText, sort: currentSortKey)) { orderHistory in
                                NavigationLink { OrderHistoryDetailView(orderHistory: orderHistory) } label: {
                                    OrderHistoryCell(orderHistory: orderHistory)
                                        .onAppear {
                                            if VM.getHistorys(searchText, sort: currentSortKey).last == orderHistory {
                                                VM.fetchOrderHistories()
                                            }
                                        }
                                        .padding(.horizontal, 20)
                                }
                            }
                        }
                        .padding(.top, 10)
                    }
                }
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
                VM.fetchOrderHistories()
            }
        }
        .fullScreenCover(isPresented: $isShowingLoginModal, onDismiss: {
            if !userEnv.isLogin {
                selectIndex = 4
            } else {
                VM.fetchOrderHistories()
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


struct SearchBarView: View {
    
    @State var isShowSort: Bool = false
    
    @Binding var currentSortKey: String
    @Binding var searchText    : String
        
    var body: some View {
        HStack {
            Image("search_icon")
                .padding(.trailing, 10)
            
            TextField("Search by order number", text: $searchText)
                .font(.callout)
            
            SeperateLineView(color: .black, height: 25, width: 1)
            
            Button {
                isShowSort.toggle()
            } label: {
                Image(currentSortKey == "ALL" ? "sort_icon" : "sort_icon_on")
            }
            
        }
        .padding(EdgeInsets(top: 10, leading: 10, bottom: 10, trailing: 10))
        .overlay(alignment: .bottom) {
            RoundedRectangle(cornerRadius: 0)
                .fill(Color(hex: "E2E2E2"))
                .frame(height: 1)
        }
        .sheet(isPresented: $isShowSort) {
            OrderHistorySortButtomSheet(isShowSortButtonSheet: $isShowSort, currentSortKey: $currentSortKey)
        }
    }
}
