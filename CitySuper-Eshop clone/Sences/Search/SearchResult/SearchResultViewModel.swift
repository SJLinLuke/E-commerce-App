//
//  SearchResultViewModel.swift
//  CitySuper-Eshop clone
//
//  Created by LukeLin on 2024/6/20.
//

import Foundation

@MainActor final class SearchResultViewModel: ObservableObject {
    
    static let shared = SearchResultViewModel()
    private let suggestionVM = SuggestionViewModel.shared
    
    @Published var isLoading      : Bool = false
    @Published var isListShowMore : Bool = false
    @Published var currcntSelected: SearchResultType = .products
    
    @Published var products      : [ProductBody] = []
    @Published var collectionList: [SearchKeywordCollection] = []
    @Published var collectionTags: [SearchKeywordCollection] = []

    var sortKey  : String = "SCORE"
    var sortOrder: HttpSortOrderKey = .DESC
   
    var totalCountNum      : Int = 0
    var isSelectProducts   : Bool { currcntSelected == .products }
    var isSelectCollections: Bool { currcntSelected == .collections }
    
    private var isHasMore: Bool = true
    private var page     : Int = 1
    
    func fetchKeywordProducts(keyword: String, collectionID: String? = nil) {
        
        guard isHasMore, !keyword.isEmpty else { return }
        
        suggestionVM.saveHistoryKeyword(keyword)
        
        Task {
            do {
                self.isLoading = true
                let response = try await NetworkManager.shared.fetchKeywordProducts(keyword, collectionID: collectionID ?? "",
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
    
    func fetchKeywordList(keyword: String) {
        Task {
            do {
                self.isLoading = true
                let response = try await NetworkManager.shared.fetchKeywordResultList(keyword)
                
                if let collections = response.collections {
                    self.collectionList = collections
                }
                
                self.isLoading = false
            } catch {
                self.isLoading = false
                print(error.localizedDescription)
            }
        }
    }
    
    func fetchKeywordCollection(keyword: String) {
        Task {
            do {
                self.isLoading = true
                let response = try await NetworkManager.shared.fetchKeywordResultCollections(keyword)
                if let product_collections = response.product_collections {
                    self.collectionTags = product_collections
                }
                
                self.isLoading = false
            } catch {
                self.isLoading = false
                print(error.localizedDescription)
            }
        }
    }
    
    func getList() -> [SearchKeywordCollection] {
        if isListShowMore {
            return collectionList
        } else {
            return Array(collectionList.prefix(3))
        }
    }
    
    func initConfig() {
        products = []
        collectionList = []
        collectionTags = []
        
        isHasMore = true
        page = 1
    }
}
