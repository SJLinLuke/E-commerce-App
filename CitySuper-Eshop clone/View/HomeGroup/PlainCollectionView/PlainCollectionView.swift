//
//  PlainCollectionView.swift
//  CitySuper-Eshop clone
//
//  Created by LukeLin on 2024/5/13.
//

import SwiftUI

struct PlainCollectionView: View {
    
    let rows = [GridItem(), GridItem()]
    let popularCategories: [PopularCategory]
    
    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            LazyHGrid(rows: rows, spacing: 10) {
                ForEach(popularCategories, id: \.self) { category in
                    NavigationLink {
                        ProductCollectionView(collectionID: category.shopify_collection_id)
                    } label: {
                        PlainCollectionItem(category: category)
                    }
                }
            }
            .frame(height: 420)
        }
        .padding(10)
    }
}

#Preview {
    PlainCollectionView(popularCategories: [PopularCategory(image_src: "", shopify_collection_id: "", title: "Beef", products: nil)])
}
