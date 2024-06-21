//
//  SearchResultCollectionsSection.swift
//  CitySuper-Eshop clone
//
//  Created by LukeLin on 2024/6/21.
//

import SwiftUI

struct SearchResultCollectionsSection: View {
    
    @StateObject var searchVM = SearchListViewModel.shared
    @StateObject var VM       = SearchResultViewModel()
    
    var body: some View {
        VStack(spacing: 0) {
            SearchHeaderView(text:
                                Text("\(VM.collectionList.count) colleciton(s) for ") + Text("\"\(searchVM.searchText)\"").bold(), titleFont: .system(size: 16), titleFontWeight: .regular, buttonTitle: VM.isListShowMore ? "Show less" : "Show all") {
                VM.isListShowMore.toggle()
            }
                                .overlay(alignment: .bottom) {
                                    SeperateLineView(color: Color(hex: "F7F7F7"), height: 2)
                                }
            
            if !VM.collectionList.isEmpty {

                ForEach(VM.getList(), id: \.self) { collection in
                    NavigationLink { ProductCollectionView(collectionID: collection.shopify_storefront_id ?? "") } label: {
                        SearchListCell(text: Text(collection.title), imageSrc: collection.image_src ?? "")
                            .padding(.vertical, -2)
                            .overlay(alignment: .bottom) {
                                SeperateLineView(color: .black)
                            }
                    }
                }
                
            }
            
            
            SearchHeaderView(text:
                                Text("\(VM.collectionTags.count) products(s) contain in below collection(s)"), titleFont: .system(size: 16), titleFontWeight: .regular)
            
            if !VM.collectionTags.isEmpty {
                FlexibleView(availableWidth: UIScreen.main.bounds.width * 0.95, data: VM.collectionTags, spacing: 5, alignment: .leading, isShowMore: true) { collection in
                    SearchTagCell(title: collection.title)
                }
                
            }
            
        }
        .task {
            VM.fetchKeywordList(keyword: searchVM.searchText)
            VM.fetchKeywordCollection(keyword: searchVM.searchText)
        }
    }
}

#Preview {
    SearchResultCollectionsSection()
}
