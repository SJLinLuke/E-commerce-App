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
    
    let itemWidth : CGFloat
    let itemHeight: CGFloat
    var isRelatedSimilar: Bool = false
    
    var meetLast: () -> Void
    
    var body: some View {
        VStack {
            HStack(alignment: .center) {
                Text(collectionNormalLayout.title)
                    .padding(.leading, 8)
                    .font(isRelatedSimilar ? .title3 : .body)
                    .fontWeight(.bold)
                
                Spacer()
                
                
                NavigationLink {
                    if isRelatedSimilar {
                        ProductDetailMoreProductsVGirdView(navTitle: collectionNormalLayout.title ,
                                                           shopifyID: collectionNormalLayout.shopify_collection_id)
                    } else {
                        ProductCollectionView(collectionID: collectionNormalLayout.shopify_collection_id,
                                              navTitle: collectionNormalLayout.title)
                    }
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
                        ProductItem(width: itemWidth, height: itemHeight, isNeedDelete: false, product: product)
                            .onAppear {
                                if collectionNormalLayout.products.last == product {
                                    meetLast()
                                }
                            }
                    }
                }
                .padding(EdgeInsets(top: 5, leading: 5, bottom: 10, trailing: 5))
            }
        }
    }
}

#Preview {
    CollectionNormalLayoutView_Normal(collectionNormalLayout: CollectionNormalLayoutModel(title: "Beef Sliced", layout: "", products: [ProductBody.mockData()], shopify_collection_id: ""), itemWidth: 150, itemHeight: 250, isRelatedSimilar: false, meetLast: {print("meetLast")})
}
