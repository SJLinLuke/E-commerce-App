//
//  ProductCollectionViewModel.swift
//  CitySuper-Eshop clone
//
//  Created by LukeLin on 2024/5/24.
//

import Foundation

@MainActor final class ProductCollectionViewModel: ObservableObject {
    
    @Published var isLoading         : Bool = false
    @Published var collectionInfo    : ProductCollectionData? = nil
    @Published var collectionProducts: [ProductBody] = []
    @Published var productsTotal     : Int = 0
    
    private var highLightProduct: ProductBody? = nil
    private var page            : Int = 1
    private var isHasMore       : Bool = true
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
        
        guard !isLoading && isHasMore else { return }
        
        Task {
            do {
                self.isLoading = true
                let collectionProductData = try await NetworkManager.shared.fetchCollectionProduct(collectionID,
                                                                                                   page: page, sortKey: self.sortKet, sortOrder: self.sortOrder)
                if let products = collectionProductData.data, !products.isEmpty {
                    self.retriveHighLightProduct(products) { productsWithoutHighLight in
                        self.collectionProducts.append(contentsOf: productsWithoutHighLight)
                        self.page += 1
                    }
                } else {
                    self.isHasMore = false
                    self.isLoading = false
                }
                
                self.productsTotal = collectionProductData.total ?? 0
                
            } catch {
                self.isLoading = false
                print(error)
            }
        }
    }

    private func retriveHighLightProduct(_ products: [ProductBody], complete: @escaping ([ProductBody]) -> Void){
        
        guard self.highLightProduct == nil else {
            self.isLoading = false
            complete(products)
            return
        }
        
        var _products = products
        
        self.highLightProduct = _products[0]
        _products.removeFirst()
        
        self.isLoading = false
        
        complete(_products)
    }
    
    func getHighLightProduct() -> ProductBody {
        if let highLightProduct = self.highLightProduct {
            return highLightProduct
        }
        return ProductBody(description_html: "", is_favourite: false, shopify_product_id: "", title: "", variants: nil, options: nil, logistic_tags: nil, image_src: nil, inventory_quantity: nil, compare_at_price: nil, price: nil, images: nil)
    }
}
