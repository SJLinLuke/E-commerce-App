//
//  SearchResultProductsListView.swift
//  CitySuper-Eshop clone
//
//  Created by LukeLin on 2024/6/21.
//

import SwiftUI

struct SearchResultProductsListView: View {
    
    @StateObject var VM       = SearchResultProductsListViewModel.shared
    @StateObject var searchVM = SearchListViewModel.shared
    
    @State var isShowResult: Bool = false
    
    let collection: SearchKeywordCollection
    
    var body: some View {
        VStack {
            ScrollView {
                HStack {
                    Text("\(VM.total) product(s) for ") + Text("\"\(searchVM.searchText)\"").bold().foregroundColor(Color(hex: "777777")) + Text(" in \(collection.title)")
                        
                    Spacer()
                }
                .padding()
                .background(Color(hex: "F2F2F2"))
                .foregroundColor(.secondary)
                
                ProductVGridView(products: VM.products, isNeedDelete: false, itemWidth: 182, itemHeight: 270, meetLast: {
                    VM.fetchCollectionProducts(collectionID: collection.shopify_storefront_id ?? "")
                })
            }
            .onAppear {
                VM.fetchCollectionProducts(collectionID: collection.shopify_storefront_id ?? "")
            }
            .modifier(NavigationModifier(isHideCollectionsList: true))
            .modifier(searchModifier(isShowResult: $isShowResult, searchText: $searchVM.searchText))
            .searchable(text: $searchVM.searchText, placement: .navigationBarDrawer(displayMode: .always), prompt: Constants.searchPrompt)
        }
        .overlay {
            if VM.isLoading {
                LoadingIndicatiorView()
            }
        }
    }
}

#Preview {
    SearchResultProductsListView(collection: SearchKeywordCollection(shopify_storefront_id: "", title: "", not_viewable: nil, image_src: nil, item_count: nil))
}
