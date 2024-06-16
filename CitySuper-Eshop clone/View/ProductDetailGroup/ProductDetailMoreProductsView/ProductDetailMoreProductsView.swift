//
//  ProductDetailMoreProductsView.swift
//  CitySuper-Eshop clone
//
//  Created by LukeLin on 2024/5/23.
//

import SwiftUI

struct ProductDetailMoreProductsView: View {
    
    let title    : String
    let shopifyID: String
    let products : [ProductBody]
    let meetLast : () -> Void
    
    var body: some View {
        ZStack {
            CollectionNormalLayoutView_Normal(
                collectionNormalLayout: CollectionNormalLayoutModel(
                    title: title,
                    layout: "",
                    products: products,
                    shopify_collection_id: shopifyID),
                    itemWidth: 175,
                    itemHeight: 270,
                    isRelatedSimilar: true, meetLast: {meetLast()}
            )
            .background(Color(hex: "F2F2F2"))
        }
    }
}

#Preview {
    ProductDetailMoreProductsView(title: "Related Products", shopifyID: "", products: [ProductBody.mockData()], meetLast: {print("testing")})
}
