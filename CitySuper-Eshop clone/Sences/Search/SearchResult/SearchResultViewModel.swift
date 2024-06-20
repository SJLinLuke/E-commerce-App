//
//  SearchResultViewModel.swift
//  CitySuper-Eshop clone
//
//  Created by LukeLin on 2024/6/20.
//

import Foundation

@MainActor final class SearchResultViewModel: ObservableObject {
    
    static let shared = SearchResultViewModel()
    
    @Published var isLoading      : Bool = false
    @Published var currcntSelected: SearchResultType = .products
    @Published var products       : [ProductBody] = []
    
    var sortKey  : String = "SCORE"
    var sortOrder: HttpSortOrderKey = .DESC
    var isHasMore: Bool = true
    
    var totalCountNum      : Int = 0
    var isSelectProducts   : Bool { currcntSelected == .products }
    var isSelectCollections: Bool { currcntSelected == .collections }
    
    private var page: Int = 1
    
    func fetchKeywordProducts(keyword: String, collectionID: String) {
        
        guard isHasMore, !keyword.isEmpty, !isLoading else { return }
        
        Task {
            do {
                self.isLoading = true
                let response = try await NetworkManager.shared.fetchKeywordProducts(keyword, collectionID: collectionID,
                                                                                    page: self.page, sortKey: self.sortKey, sortOrder: self.sortOrder)
                
                self.isHasMore = Int(response.current_page ?? "0") ?? 0 < response.total_page ?? 0
                self.page += 1
                self.totalCountNum = response.total_record ?? 0
                
                if let products = response.products {
                    self.products.append(contentsOf: products)
                } else {
                    if let suggest_products = response.suggest_products {
                        self.products = suggest_products
                    }
                }
                self.isLoading = false
            } catch {
                self.isLoading = false
                print(error.localizedDescription)
            }
        }
    }
}
