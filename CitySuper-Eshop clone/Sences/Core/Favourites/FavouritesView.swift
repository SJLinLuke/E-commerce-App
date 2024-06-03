//
//  FavoriteView.swift
//  CitySuper-Eshop clone
//
//  Created by LukeLin on 2024/5/9.
//

import SwiftUI

struct FavouritesView: View {
    
    @EnvironmentObject var userEnv: UserEnviroment
    
    @StateObject var VM = FavouriteViewModel.shared
    
    @State var isShowingLoginModal: Bool = false
    @State var searchText: String = ""

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
                    }
                }
            }
            .modifier(NavigationModifier())
            .searchable(text: $searchText, placement: .navigationBarDrawer(displayMode: .always))
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
    }
}

#Preview {
    FavouritesView()
        .environmentObject(UserEnviroment())
}
