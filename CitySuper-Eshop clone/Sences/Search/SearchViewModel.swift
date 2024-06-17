//
//  SearchViewModel.swift
//  CitySuper-Eshop clone
//
//  Created by LukeLin on 2024/6/17.
//

import Foundation

@MainActor final class SearchViewModel: ObservableObject {
    
    static let shared = SearchViewModel()
    
    @Published var searchText: String = ""
    
}
