//
//  SearchResultView.swift
//  CitySuper-Eshop clone
//
//  Created by LukeLin on 2024/6/21.
//

import SwiftUI

struct SearchResultView: View {
    
    @StateObject var searchVM = SearchListViewModel.shared
    @StateObject var VM       = SearchResultViewModel.shared
    
    @State var keyword: String?
    
    var body: some View {
        ScrollView {
            VStack(spacing: 0) {
               
                SearchResultHeaderView(currentSelected: $VM.currcntSelected)
                
                if VM.isSelectProducts {
                    SearchResultProductsSection()
                }
                
                if VM.isSelectCollections {
                    SearchResultCollectionsSection()
                }
                
            }
        }
        .overlay {
            if VM.isLoading {
                LoadingIndicatiorView()
            }
        }
        .onAppear {
            if let keyword = keyword {
                VM.initConfig()
                searchVM.searchText = keyword
            }
        }
        .modifier(NavigationModifier(isHideCollectionsList: true))
        .searchable(text: $searchVM.searchText, placement: .navigationBarDrawer(displayMode: .always), prompt: Constants.searchPrompt)
        .onSubmit(of: .search) {
            keyword = searchVM.searchText
            VM.initConfig()
            VM.fetchKeywordProducts(keyword: searchVM.searchText)
            VM.fetchKeywordList(keyword: searchVM.searchText)
            VM.fetchKeywordCollection(keyword: searchVM.searchText)
        }
    }
}

#Preview {
    SearchResultView()
        .environmentObject(CartEnvironment())
}
