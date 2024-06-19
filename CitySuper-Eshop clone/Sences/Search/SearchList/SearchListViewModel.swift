//
//  SearchListViewModel.swift
//  CitySuper-Eshop clone
//
//  Created by LukeLin on 2024/6/19.
//

import Foundation

@MainActor final class SearchListViewModel: ObservableObject {
    
    static let shared = SearchListViewModel()
    
    @Published var isLoading          : Bool = false
    
    @Published var brands             : [String] = []
    @Published var collections        : [SearchKeywordCollection] = []
    @Published var product_collections: [SearchKeywordCollection] = []
    
    @Published var searchText: String = "" {
        didSet {
            pendingKeywordToSearch(keyword: searchText)
        }
    }
    
    private var debounceWorkItem: DispatchWorkItem?
    private var pendingKeywords : [String] = []
    
    @objc private func searchKeyword() {
        
        guard let lastKeywordToExecute = pendingKeywords.last, !lastKeywordToExecute.isEmpty else { return }
        
        pendingKeywords.removeAll()
        
        Task {
            do {
                self.isLoading = true
                let SearchKeywordData = try await NetworkManager.shared.fetchKeyword(lastKeywordToExecute)
                
                if let brands = SearchKeywordData.brands {
                    self.brands = brands
                }
                
                if let collections = SearchKeywordData.collections {
                    self.collections = collections
                }
                
                if let product_collections = SearchKeywordData.product_collections {
                    self.product_collections = product_collections
                }
                self.isLoading = false
            } catch {
                self.isLoading = false
                print(error.localizedDescription)
            }
        }
    }
    
    private func pendingKeywordToSearch(keyword: String) {
                
        pendingKeywords.append(keyword)
        
        debounce(#selector(searchKeyword), delay: 0.5)
    }
   
    private func debounce(_ selector: Selector, delay: TimeInterval) {
        // Cancel any existing work item to prevent previous tasks from executing
        debounceWorkItem?.cancel()
        
        // Create a new work item to execute the function
        debounceWorkItem = DispatchWorkItem { [weak self] in
            self?.searchKeyword()
        }
        
        // Schedule the work item after the specified delay
        if let workItem = debounceWorkItem {
            DispatchQueue.main.asyncAfter(deadline: .now() + delay, execute: workItem)
        }
    }
}
