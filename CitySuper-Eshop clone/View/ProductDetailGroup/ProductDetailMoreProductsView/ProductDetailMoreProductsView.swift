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
                collectionNormalLayout: CollectionNormalLayoutModel(title: title,
                                                                    layout: "",
                                                                    products: products,
                                                                    shopify_collection_id: shopifyID),
                itemWidth: 175,
                itemHeight: 270,
                isRelatedSimilar: true, meetLast: {meetLast()})
            .background(Color(hex: "F2F2F2"))
        }
    }
}

#Preview {
    ProductDetailMoreProductsView(title: "Related Products", shopifyID: "", products: [ProductBody(description_html: "", is_favourite: false, shopify_product_id: "", title: "1 Italian Veal Tongue [PreViously Frozen] (300g)", variants: nil, options: nil, logistic_tags: nil, image_src: "", inventory_quantity: 0, compare_at_price: nil, price: "69.99", images: nil, products: nil, similar_products: nil)], meetLast: {print("testing")})
}
