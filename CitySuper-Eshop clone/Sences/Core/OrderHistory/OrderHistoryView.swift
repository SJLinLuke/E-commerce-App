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
            VStack {
                
                SearchBarView()
                
                List() {
                    OrderHistoryCell()
                    OrderHistoryCell()
                }
                .listStyle(.plain)
                .padding(.top, -8)
                
                
                Spacer()
            }
            .navigationTitle("Order History")
            .navigationBarTitleDisplayMode(.inline)
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
//        .fullScreenCover(isPresented: $isShowingLoginModal, onDismiss: {
//            if !userEnv.isLogin {
//                selectIndex = 4
//            }
//        }, content: {
//            LoginView(isShowingModal: $isShowingLoginModal)
//        })
        
    }
}

#Preview {
    OrderHistoryView(selectIndex: .constant(1))
        .environmentObject(UserEnviroment())
}

struct OrderHistoryCell: View {
    var body: some View {
        ZStack{
            VStack(alignment: .leading) {
                HStack {
                    Text("Order# 10515")
                        .fontWeight(.bold)
                    Spacer()
                    Text("Processing")
                        .fontWeight(.bold)
                        .foregroundColor(.themeGreen2)
                }
                Text("2024/05/16 16:44:56")
                    .font(.caption)
                    .foregroundColor(.secondary)
                
                Progress(height: 7, figureTarget: 180, color: .themeGreen2)
                
                Spacer()
                    .frame(height: 45)
                
                Text("Amount: HK$660.48")
            }
            .padding(8)
            .background(.white)
            .cornerRadius(10)
            .shadow(color: .secondary, radius: 3, x: 1, y: 1)
        }
        .padding(.horizontal, -13)
        .padding(.bottom, 9)
        .listRowSeparator(.hidden, edges: .all)
    }
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
