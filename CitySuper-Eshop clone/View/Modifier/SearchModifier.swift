//
//  SearchModifier.swift
//  CitySuper-Eshop clone
//
//  Created by LukeLin on 2024/6/16.
//

import SwiftUI

struct searchModifier: ViewModifier {
    
    @Environment(\.isSearching) var isSearching
    
    @Binding var searchText: String
    
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
    }
}

struct SearchResult: View {
    var body: some View {
        Text("SearchResult")
    }
}


#Preview {
    SearchResult()
}
