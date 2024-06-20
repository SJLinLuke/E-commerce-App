//
//  SearchRecommendationView.swift
//  CitySuper-Eshop clone
//
//  Created by LukeLin on 2024/6/20.
//

import SwiftUI

struct SearchRecommendationView: View {
    
    let recommendationCollections: [recommendKeywords]
    
    private let width = UIScreen.main.bounds.width / 2.25
    
    var body: some View {
        LazyVGrid(columns: [GridItem(.adaptive(minimum: width, maximum: width))]) {
            ForEach(recommendationCollections) { collection in
                NavigationLink {
                    ProductCollectionView(collectionID: collection.shopify_storefront_id)
                } label: {
                    RemoteImageView(url: collection.image_src ?? "", placeholder: .common)
                        .aspectRatio(contentMode: .fit)
                        .frame(height: 170)
                }
            }
        }
        .padding(.bottom)
    }
}

#Preview {
    SearchRecommendationView(recommendationCollections: [])
}
