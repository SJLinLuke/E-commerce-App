//
//  SearchListView.swift
//  CitySuper-Eshop clone
//
//  Created by LukeLin on 2024/6/20.
//

import SwiftUI

struct SearchListView: View {
    
    @StateObject var VM = SearchListViewModel.shared
    
    var body: some View {
        ScrollView {
            VStack(spacing: 0) {
                
                if !VM.brands.isEmpty {
                    SearchHeaderView(title: "Brand")
                        .background(Color(hex: "F2F2F2"))
                    
                    ForEach(VM.brands, id: \.self) { brand in
                        NavigationLink { SearchResult(keyword: brand) } label: {
                            SearchListCell(text: Text(brand), icon: "search_shop_icon")
                                .background(.white)
                                .overlay(alignment: .bottom) {
                                    if brand != VM.brands.last {
                                        SeperateLineView(color: .black)
                                    }
                                }
                        }
                    }
                }
                
                if !VM.collections.isEmpty {
                    SearchHeaderView(title: "Keyword Suggestions")
                        .background(Color(hex: "F2F2F2"))
                    
                    ForEach(VM.collections, id: \.self) { collection in
                        NavigationLink { SearchResult(keyword: collection.title) } label: {
                            SearchListCell(text: Text(collection.title), icon: "search_icon")
                                .background(.white)
                                .overlay(alignment: .bottom) {
                                    if collection != VM.collections.last {
                                        SeperateLineView(color: .black)
                                    }
                                }
                        }
                    }
                }
                
                if !VM.product_collections.isEmpty {
                    SearchHeaderView(title: "Keyword Under Categories")
                        .background(Color(hex: "F2F2F2"))
                    
                    ForEach(VM.product_collections, id: \.self) { collection in
                        NavigationLink {  ProductCollectionView(collectionID: collection.shopify_storefront_id ?? "") } label: {
                            SearchListCell(text: Text(collection.title), icon: "search_icon")
                                .background(.white)
                                .overlay(alignment: .bottom) {
                                    if collection != VM.product_collections.last {
                                        SeperateLineView(color: .black)
                                    }
                                }
                        }
                    }
                }
                
                SeperateLineView(color: Color(hex: "F2F2F2"), height: 20)
                
                HStack {
                    SearchListCell(text:
                                    Text("Show all results for ") +
                                   Text("\"\(VM.searchText)\"").bold().foregroundColor(.gray)
                                   , icon: "", isAccessoryIcon: false)
                    if VM.isLoading {
                        ProgressView()
                            .padding(.trailing)
                    }
                }
                
            }
        }
    }
}

#Preview {
    SearchListView()
}
