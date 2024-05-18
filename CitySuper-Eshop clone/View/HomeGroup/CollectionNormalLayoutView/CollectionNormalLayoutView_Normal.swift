//
//  CollectionNormalLayoutView.swift
//  CitySuper-Eshop clone
//
//  Created by LukeLin on 2024/5/11.
//

import SwiftUI

struct CollectionNormalLayoutView_Normal: View {
    
    let rows = [GridItem()]
    let collectionNormalLayout: CollectionNormalLayoutModel
    
    var body: some View {
        VStack {
            HStack(alignment: .bottom) {
                Text(collectionNormalLayout.title)
                    .padding(.leading, 8)
                    .font(.body)
                    .fontWeight(.bold)
                
                Spacer()
                
                Button {
                    
                } label: {
                    AllButton()
                        .padding(.trailing, 8)
                }
            }
            .padding(.top, 10)
            .padding(.bottom, 5)
            
            ScrollView(.horizontal, showsIndicators: false) {
                LazyHGrid(rows: rows) {
                    ForEach(collectionNormalLayout.products, id: \.self) { product in
                        ProductItem(product: product, width: 150, height: 250, isNeedDelete: false)
                    }
                }
                .padding(EdgeInsets(top: 5, leading: 5, bottom: 10, trailing: 5))
            }
        }
    }
}

#Preview {
    CollectionNormalLayoutView_Normal(collectionNormalLayout: CollectionNormalLayoutModel(title: "Beef Sliced", layout: "", products: [ProductBody(description_html: "", is_favourite: false, shopify_product_id: "", title: "1 Itailian Veal Tongue [Previous Forzen] (300g)", variants: nil, options: nil, logistic_tags: nil, image_src: "", inventory_quantity: 0, compare_at_price: "40", price: "69.00", images: nil, products: nil, similar_products: nil)], shopify_collection_id: ""))
}
