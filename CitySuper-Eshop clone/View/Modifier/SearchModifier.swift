//
//  SearchModifier.swift
//  CitySuper-Eshop clone
//
//  Created by LukeLin on 2024/6/16.
//

import SwiftUI

struct searchModifier: ViewModifier {
    
    @Environment(\.isSearching) var isSearching
    
    @Binding var isShowResult: Bool
    @Binding var searchText  : String
    
    func body(content: Content) -> some View {
        ZStack {
            if isSearching {
                if searchText.isEmpty {
                    SuggestionView()
                } else {
                    SearchListView()
                }
            } else {
                content
            }
        }
        .navigationDestination(isPresented: $isShowResult) {
            SearchResultView(keyword: searchText)
        }
    }
}

#Preview {
    SearchResultView()
        .environmentObject(CartEnvironment())
}
