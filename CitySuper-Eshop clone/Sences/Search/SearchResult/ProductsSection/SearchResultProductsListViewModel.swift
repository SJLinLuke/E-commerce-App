//
//  SearchResultProductsListViewModel.swift
//  CitySuper-Eshop clone
//
//  Created by LukeLin on 2024/6/21.
//

import Foundation

@MainActor final class SearchResultProductsListViewModel: ObservableObject {
    
    static let shared = SearchResultProductsListViewModel()
    
    @Published var isLoading: Bool = false
    
    @Published var products: [ProductBody] = []
    @Published var total   : Int = 0
    
    private var isHasMore: Bool = true
    private var page     : Int = 1
    
    func fetchCollectionProducts(collectionID: String) {
        
        guard !isLoading, isHasMore else { return }
        
        Task {
            do {
                self.isLoading = true
                
                let response = try await NetworkManager.shared.fetchCollectionAllProduct(collectionID, page: page)
                
                self.products.append(contentsOf: response.data ?? [])
                
                self.total = response.total ?? 0
                self.page += 1
                self.isHasMore = response.next_page_url != nil
                
                self.isLoading = false
            } catch {
                print(error.localizedDescription)
                self.isLoading = false
            }
        }
    }
}
