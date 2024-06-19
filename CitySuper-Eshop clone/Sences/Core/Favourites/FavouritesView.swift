//
//  FavoriteView.swift
//  CitySuper-Eshop clone
//
//  Created by LukeLin on 2024/5/9.
//

import SwiftUI

struct FavouritesView: View {
    
    @EnvironmentObject var userEnv: UserEnviroment
    
    @StateObject private var VM       = FavouriteViewModel.shared
    @StateObject private var searchVM = SearchListViewModel.shared

    @State var isShowingLoginModal: Bool = false

    var body: some View {
        NavigationStack {
            VStack {
                if (VM.favourites.isEmpty) { FavouritesEmptyView() } else {
                    ScrollView {
                        ProductVGridView(products: VM.favourites, isNeedDelete: true, itemWidth: 182, itemHeight: 270, meetLast: {
                            if (VM.isHasMore && !VM.favourites.isEmpty) {
                                VM.fetchFavourite()
                            }
                        })
                        .padding(.bottom)
                    }
                }
            }
            .modifier(NavigationModifier())
            .modifier(searchModifier(searchText: $searchVM.searchText))
        }
        .overlay {
            if (VM.isLoading) {
                LoadingIndicatiorView()
            }
        }
        .task {
            if userEnv.isLogin && VM.favourites.isEmpty {
                VM.fetchFavourite()
            }
        }
        .onAppear {
            DispatchQueue.main.async {
                self.isShowingLoginModal = !userEnv.isLogin
            }
        }
        .searchable(text: $searchVM.searchText, placement: .navigationBarDrawer(displayMode: .always), prompt: Constants.searchPrompt)
    }
}

#Preview {
    FavouritesView()
        .environmentObject(UserEnviroment())
}
