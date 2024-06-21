//
//  SearchResultView.swift
//  CitySuper-Eshop clone
//
//  Created by LukeLin on 2024/6/21.
//

import SwiftUI

struct SearchResultView: View {
    
    @StateObject var searchVM = SearchListViewModel.shared
    @StateObject var VM       = SearchResultViewModel()
    
    @State private var isShowResult: Bool = false

    var keyword     : String = ""
    
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
                
                Spacer()
            }
        }
        .overlay {
            if VM.isLoading {
                LoadingIndicatiorView()
            }
        }
        .onAppear {
            searchVM.searchText = keyword
        }
        .modifier(NavigationModifier(isHideCollectionsList: true))
        .searchable(text: $searchVM.searchText, placement: .navigationBarDrawer(displayMode: .always), prompt: Constants.searchPrompt)
        .onSubmit(of: .search) {
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
