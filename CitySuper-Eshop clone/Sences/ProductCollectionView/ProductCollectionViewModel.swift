//
//  ProductCollectionViewModel.swift
//  CitySuper-Eshop clone
//
//  Created by LukeLin on 2024/5/24.
//

import Foundation

@MainActor final class ProductCollectionViewModel: ObservableObject {
    
    @Published var isLoading            : Bool = false
    @Published var collectionInfo       : ProductCollectionData? = nil
    @Published var collectionProductData: CollectionProductsData? = nil
    
    private var highLightProduct: ProductBody? = nil
    private var page            : Int = 1
    private var isHasMore       : Bool = false
    private var sortKet         : ProductCollectionSortKeys = .manual
    private var sortOrder       : HttpSortOrderKey = .ASC
    
    func fetchCollection(collectionID: String) {

        Task {
            do {
                self.collectionInfo = try await NetworkManager.shared.fetchCollectionInfo(collectionID)
            } catch {
                print(error.localizedDescription)
            }
        }
    }
    
    func fetchCollectionProducts(collectionID: String) {
        
        guard !isLoading else { return }
        
        Task {
            do {
                self.isLoading = true
                self.collectionProductData = try await NetworkManager.shared.fetchCollectionProduct(collectionID,
                                                                                                 page: page, sortKey: self.sortKet, sortOrder: self.sortOrder)
                self.retriveHighLightProduct()
            } catch {
                self.isLoading = false
                print(error)
            }
        }
    }

    private func retriveHighLightProduct() {
        
        guard var collectionProducts = self.collectionProductData?.data, collectionProducts.count > 0 else {
            self.isLoading = false
            return
        }
        
        self.highLightProduct = collectionProducts[0]
        collectionProducts.removeFirst()
        
        self.collectionProductData?.data = collectionProducts
        
        self.isLoading = false
    }
    
    func getHighLightProduct() -> ProductBody {
        if let highLightProduct = self.highLightProduct {
            return highLightProduct
        }
        return ProductBody(description_html: "", is_favourite: false, shopify_product_id: "", title: "", variants: nil, options: nil, logistic_tags: nil, image_src: nil, inventory_quantity: nil, compare_at_price: nil, price: nil, images: nil)
    }
}
