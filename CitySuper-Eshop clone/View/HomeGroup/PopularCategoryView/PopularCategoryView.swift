//
//  PopularCategory.swift
//  CitySuper-Eshop clone
//
//  Created by LukeLin on 2024/5/11.
//

import SwiftUI

struct PopularCategoryView: View {
    
    let rows = [GridItem(), GridItem()]
    let popularCategories: [PopularCategory]

    var body: some View {
        VStack(alignment: .leading) {
            Text("Popular Categories")
                .font(.body)
                .fontWeight(.bold)
            
            ScrollView(.horizontal, showsIndicators: false) {
                LazyHGrid(rows: rows, spacing: 30, content: {
                    ForEach(popularCategories, id: \.self) { category in
                        NavigationLink { ProductCollectionView(collectionID: category.shopify_collection_id, navTitle: category.title) } label: {
                            PopularCategoryItem(imageSrc: category.image_src ?? "", title: category.title)
                        }
                    }
                })
                .padding(EdgeInsets(top: 0, leading: 20, bottom: 0, trailing: 0))
            }
        }
        .padding(EdgeInsets(top: 10, leading: 5, bottom: 20, trailing: 5))
    }
}

#Preview {
    PopularCategoryView(popularCategories: [PopularCategory(image_src: "https://mobilestouat.citysuper.com.hk/eshop/collections/collections_icon_02-Pork62d7a55298542.png", shopify_collection_id: "", title: "Pork", products: nil)])
}
