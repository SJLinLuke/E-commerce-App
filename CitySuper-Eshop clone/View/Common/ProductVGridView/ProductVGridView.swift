//
//  ProductVGridView.swift
//  CitySuper-Eshop clone
//
//  Created by LukeLin on 2024/5/13.
//

import SwiftUI


struct ProductVGridView: View {
    let colums = [GridItem(),GridItem()]
    
    let products    : [ProductBody]
    let isNeedDelete: Bool
    
    var meetLast: () -> Void
    
    var body: some View {
        LazyVGrid(columns: colums, spacing: 10) {
            ForEach(products, id: \.self) { product in
                ProductItem(product: product, width: 182, height: 270, isNeedDelete: isNeedDelete)
                    .onAppear {
                        if (products.last == product) {
                            meetLast()
                        }
                    }
                    .onTapGesture {
                        print(product.is_favourite)
                    }
            }
        }
    }
    
}


#Preview {
    ProductVGridView(products: [ProductBody(description_html: "", is_favourite: false, shopify_product_id: "", title: "Beef", variants: nil, options: nil, logistic_tags: nil, image_src: "", inventory_quantity: 1, compare_at_price: "100", price: "69.00", images: nil, products: nil, similar_products: nil)], isNeedDelete: false, meetLast: {print("meetLast")} )
}
