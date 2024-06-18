//
//  SearchViewModel.swift
//  CitySuper-Eshop clone
//
//  Created by LukeLin on 2024/6/17.
//

import Foundation
import SwiftUI

@MainActor final class SearchViewModel: ObservableObject {
    
    static let shared = SearchViewModel()
    
    @AppStorage("searchHistoryKeywords") private var storage_historyKeywords: Data?
    
    @Published var searchText: String = ""
    
    @Published var isLoading        : Bool = false
    @Published var historyKeywords  : [String] = []
    @Published var hotKeywords      : [String] = []
    @Published var recommendKeywords: [recommendKeywords] = []
    
    init() {
        self.historyKeywords = retriveHistoryKeyword()
    }
    
    func fetchSuggestion() {
        
        guard !isLoading else { return }
        
        Task {
            do {
                self.isLoading = true
                let suggestion = try await NetworkManager.shared.fetchSuggestion()
                self.hotKeywords = suggestion.hot_keywords
                self.recommendKeywords = suggestion.recommend_collections
                self.isLoading = false
            } catch {
                self.isLoading = false
            }
        }
    }
    
    private func retriveHistoryKeyword() -> [String] {
        
        guard let storedHistoryKeywords = self.storage_historyKeywords else {
            return []
        }
        
        do {
            return try JSONDecoder().decode([String].self, from: storedHistoryKeywords)
        } catch {
            print("something went wrong when retriving historyKeywords")
            return []
        }
    }
    
    private func saveHistoryKeyword(_ keyword: String) {
        
        guard !historyKeywords.contains(keyword) else { return }
        
        historyKeywords.append(keyword)
        
        do {
            let data = try JSONEncoder().encode(historyKeywords)
            self.storage_historyKeywords = data
        } catch {
            print("something went wrong when encode qrcode data")
        }
    }
}
