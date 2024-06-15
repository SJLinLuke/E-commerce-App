//
//  MoreCollectionsListViewModel.swift
//  CitySuper-Eshop clone
//
//  Created by LukeLin on 2024/6/15.
//

import Foundation

@MainActor final class MoreCollectionsListViewModel: ObservableObject {
    
    static let shared = MoreCollectionsListViewModel()
    
    @Published var isLoading                  : Bool = false
    @Published var isShowCollectionProductList: Bool = false
    
    @Published private var collections        : [NavigationsData]?
    
    @Published var selectedCollection         : NavigationsData? {
        didSet {
            isShowCollectionProductList.toggle()
        }
    }

    @Published var currentSub                 : SubHistory?
    @Published var subHistory                 : [SubHistory] = []
    
    func fetchCollectionsList() {
        
        guard !isLoading else { return }
        
        Task {
            do {
                self.isLoading = true
                self.collections = try await NetworkManager.shared.fetchNavigations()
                self.isLoading = false
            } catch {
                print(error.localizedDescription)
                self.isLoading = false
            }
        }
    }
    
    func getCollections(currentCollections: NavigationsData? = nil, sub: [NavigationsData]? = nil) -> [NavigationsData] {
        
        if let sub = sub {
            return sub
        } else {
            return self.collections ?? []
        }
    }
    
    func tapOnCell(_ collection: NavigationsData) {
        
        if let sub = collection.sub_collections {
            let newSubHistory = SubHistory(title: collection.title, collections: sub)
            subHistory.append(newSubHistory)
            currentSub = newSubHistory
        } else {
            selectedCollection = collection
        }
    }
}
