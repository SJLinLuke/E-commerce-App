//
//  FavouriteViewModel.swift
//  CitySuper-Eshop clone
//
//  Created by LukeLin on 2024/5/18.
//

enum FavModifyType {
    case add
    case remove
}

import Foundation

@MainActor final class FavouriteViewModel: ObservableObject {
    
    static let shared = FavouriteViewModel()
    
    @Published var isLoading : Bool = false
    @Published var isHasMore : Bool = true
    @Published var favourites: [ProductBody] = []
    
    private var currentPage: Int = 1
    
    func fetchFavourite() {
        
        guard !isLoading else { return }
        
        Task {
            do {
                self.isLoading = true
                
                let favouriteData = try await NetworkManager.shared.fetchFavourites(self.currentPage)
                
                self.favourites.append(contentsOf: favouriteData.data)
                
                self.isLoading = false
                
                if (self.currentPage != favouriteData.last_page) {
                    self.currentPage += 1
                    self.fetchFavourite()
                } else {
                    self.isHasMore = false
                }
            } catch {
                self.isLoading = false
                print(error.localizedDescription)
            }
        }
    }
    
    func addFavourite(product: ProductBody) {
        
        let shopifyID = product.shopify_product_id
        
        guard !shopifyID.isEmpty, !isFavourite(shopifyID: shopifyID) else { return }
        
        favourites.append(product)
        
        Task {
            let response = try await NetworkManager.shared.modifyFavourite(shopifyID, method: .add)
            
            switch response {
            case .success(_):
                debugPrint("add favourite successfully.")
            case .failure(let error):
                debugPrint("something wnet wrong when adding favourite: \(error.localizedDescription).")
            }
        }
    }
    
    func removeFavourite(product: ProductBody) {
        
        let shopifyID = product.shopify_product_id
        
        guard !shopifyID.isEmpty, isFavourite(shopifyID: shopifyID) else { return }
        
        favourites = favourites.filter({ favourite in
            favourite.shopify_product_id.shopifyIDEncode != product.shopify_product_id.shopifyIDEncode
        })
        
        Task {
            let response = try await NetworkManager.shared.modifyFavourite(shopifyID, method: .remove)
            
            switch response {
            case .success(_):
                debugPrint("remove favourite successfully.")
            case .failure(let error):
                debugPrint("something wnet wrong when removeing favourite: \(error.localizedDescription).")
            }
        }
    }
    
    func isFavourite(shopifyID: String) -> Bool {
        
        guard !shopifyID.isEmpty else { return false }
        
        let currentFavs = Set(self.favourites.map{ $0.shopify_product_id.shopifyIDEncode })
        return currentFavs.contains(shopifyID)
    }
    
    func initFavourites() {
        self.favourites  = []
        self.isLoading   = false
        self.isHasMore   = true
        self.currentPage = 1
    }
}
