//
//  FavouriteViewModel.swift
//  CitySuper-Eshop clone
//
//  Created by LukeLin on 2024/5/18.
//

import Foundation

@MainActor final class FavouriteViewModel: ObservableObject {
    
    @Published var isLoading : Bool = false
    @Published var isHasMore : Bool = true
    @Published var favourites: [ProductBody] = []
    
    private var currentPage: Int = 1
    
    func fetchFavourite() {
        
        guard !isLoading else { return }
        
        DispatchQueue.main.async {
            Task {
                do {
                    self.isLoading = true
                    
                    let favouriteData = try await NetworkManager.shared.fetchFavourites(self.currentPage)
                    
                    if (self.currentPage != favouriteData.last_page) {
                        self.currentPage += 1
                    } else {
                        self.isHasMore = false
                    }
       
                    self.favourites.append(contentsOf: favouriteData.data)
                    
                    self.isLoading = false
                } catch {
                    self.isLoading = false
                    print(error.localizedDescription)
                }
            }
        }
    }
    
}
