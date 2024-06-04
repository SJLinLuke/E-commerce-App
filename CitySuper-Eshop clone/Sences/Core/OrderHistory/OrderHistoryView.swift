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
    
    @State var searchText         : String = ""
    @State var isShowingLoginModal: Bool = false

    @StateObject var VM = OrderHistoryViewModel.shared
    
    var body: some View {
        NavigationStack {
            VStack {
                SearchBarView(searchText: $searchText)
                
                ScrollView {
                    LazyVGrid(columns: [GridItem()]) {
                        ForEach(VM.getHistorys(searchText)) { orderHistory in
                            NavigationLink { OrderHistoryDetailView(orderHistory: orderHistory) } label: {
                                OrderHistoryCell(orderHistory: orderHistory)
                                    .onAppear {
                                        if VM.getHistorys(searchText).last == orderHistory {
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
    
    @State var isSorting : Bool = true
    @State var isSelected : String = "ALL"
    @Binding var searchText: String
    var arr = ["Payment Pending", "Processing", "Refunded", "Completed", "ALL"]
    var body: some View {
        HStack {
            Image("search_icon")
                .padding(.trailing, 10)
            
            TextField("Search by order number", text: $searchText)
                .font(.callout)
            
            SeperateLineView(color: .black, height: 25, width: 1)
            
            Button {
                isSorting.toggle()
            } label: {
                Image(isSelected == "ALL" ? "sort_icon" : "sort_icon_on")
            }
            
        }
        .padding(EdgeInsets(top: 10, leading: 10, bottom: 10, trailing: 10))
        .overlay(alignment: .bottom) {
            RoundedRectangle(cornerRadius: 0)
                .fill(Color(hex: "E2E2E2"))
                .frame(height: 1)
        }
        .sheet(isPresented: $isSorting) {
            VStack {
                HStack {
                    Text("Filter by")
                        .font(.headline)
                        .fontWeight(.bold)
                    Spacer()
                }
                SeperateLineView(color: .gray, height: 1)

                HStack {
                    Text("Status")
                        .font(.caption)
                        .fontWeight(.medium)
                    Spacer()
                }
                .padding(EdgeInsets(top: 2, leading: 0, bottom: 10, trailing: 0))
                
                GeometryReader(content: { geometry in
                    LazyVGrid(columns: [GridItem(), GridItem()], spacing: 25, content: {
                        ForEach(arr, id: \.self) { item in
                            Button {
                                isSelected = item
                                isSorting = false
                            } label: {
                                Text(item)
                                    .frame(width: geometry.size.width * 0.48, height: 25)
                                    .font(.caption)
                                    .fontWeight(item == isSelected ? .regular : .medium)
                                    .foregroundColor(item == isSelected ? .themeGreen : .gray)
                                    .background(item == isSelected ? .white : Color(hex: "F2F2F2"))
                                    .cornerRadius(5)
                                    .overlay {
                                        if item == isSelected {
                                            RoundedRectangle(cornerRadius: 5)
                                                .stroke(
                                                    LinearGradient(
                                                        colors: [
                                                                Color(hex: "20741B"),
                                                                Color(hex: "7DE489")],
                                                        startPoint: .bottomTrailing,
                                                        endPoint: .topLeading))
                                        }
                                    }
                            }
                        }
                    })
                })
                
                Spacer()
            }
            .padding(EdgeInsets(top: 40, leading: 10, bottom: 0, trailing: 10))
            .presentationDetents([.medium, .large, .height(UIScreen.main.bounds.height / 3.2)])
            .presentationBackgroundInteraction(.disabled)
            .presentationCornerRadius(20)
        }
    }
}
