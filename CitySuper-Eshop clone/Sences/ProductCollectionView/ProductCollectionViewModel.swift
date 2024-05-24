//
//  ProductCollectionViewModel.swift
//  CitySuper-Eshop clone
//
//  Created by LukeLin on 2024/5/24.
//

import Foundation

@MainActor final class ProductCollectionViewModel: ObservableObject {
    
    @Published var isLoading: Bool = false
    @Published var collectionInfo: ProductCollectionData?
    @Published var collectionProducts: CollectionProductsData?
    
    private var page     : Int = 1
    private var isHasMore: Bool = false
    private var sortKet  : ProductCollectionSortKeys = .manual
    private var sortOrder: HttpSortOrderKey = .DESC
    
    func fetchCollection(collectionID: String) {
        
        guard !isLoading else { return }
        
        Task {
            do {
                self.isLoading = true
                self.collectionInfo = try await NetworkManager.shared.fetchCollectionInfo(collectionID)
            } catch {
                self.isLoading = false
                print(error.localizedDescription)
            }
        }
    }
    
    func fetchCollectionProducts(collectionID: String) {
        
        guard !isLoading else { return }
        
        Task {
            do {
                self.isLoading = true
                self.collectionProducts = try await NetworkManager.shared.fetchCollectionProduct(collectionID,
                                                                                                 page: page, sortKey: self.sortKet, sortOrder: self.sortOrder)
            } catch {
                self.isLoading = false
                print(error)
            }
        }
    }

    
}
