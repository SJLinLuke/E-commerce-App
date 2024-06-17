//
//  MoreCollectionsListView.swift
//  CitySuper-Eshop clone
//
//  Created by LukeLin on 2024/5/18.
//

import SwiftUI

struct MoreCollectionsListView: View {
    
    @StateObject private var VM       = MoreCollectionsListViewModel.shared
    @StateObject private var searchVM = SearchViewModel.shared
    
    @State var searchText: String = ""
    
    var body: some View {
        NavigationStack {
            VStack(spacing: 0) {
                
                if !VM.subHistory.isEmpty {
                    MoreCollectionListHeaderView()
                }
                
                List {
                    ForEach(VM.getCollections(sub: VM.currentSub?.collections), id: \.self) { collection in
                        
                        CustomListCell(rowData: CustomListRowModel(title: collection.title, icon: "arrow_icon", seperateType: true))
                            .onTapGesture {
                                VM.tapOnCell(collection)
                            }
                    }
                }
                .listStyle(.plain)
            }
            .overlay {
                if VM.isLoading {
                    LoadingIndicatiorView()
                }
            }
            .task {
                VM.fetchCollectionsList()
            }
            .modifier(NavigationModifier())
            .modifier(searchModifier(searchText: $searchVM.searchText))
            .searchable(text: $searchVM.searchText, placement: .navigationBarDrawer(displayMode: .always))
            .navigationBarBackButtonHidden()
        }
        .navigationDestination(isPresented: $VM.isShowCollectionProductList) {
            if let selectedCollection = VM.selectedCollection {
                ProductCollectionView(
                    collectionID: selectedCollection.shopify_collection_id,
                    navTitle: selectedCollection.title)
            }
        } 
    }
}

#Preview {
    MoreCollectionsListView()
        .environmentObject(UserEnviroment())
        .environmentObject(CartEnvironment())
}
