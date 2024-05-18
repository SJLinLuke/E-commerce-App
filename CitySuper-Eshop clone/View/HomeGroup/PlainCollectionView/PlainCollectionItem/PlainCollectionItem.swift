//
//  PlainCollectionItem.swift
//  CitySuper-Eshop clone
//
//  Created by LukeLin on 2024/5/13.
//

import SwiftUI

struct PlainCollectionItem: View {
    
    let category: PopularCategory
    
    init(category: PopularCategory) {
        self.category = category
    }
    
    var body: some View {
        VStack {
            RemoteImageView(url: category.image_src ?? "",
                            placeholder: .common)
            
            HStack {
                Text(category.title)
                    .font(.system(size: 14))
                    .lineLimit(1)
                
                Spacer()
                
                Image("arrow_icon")
            }
            .padding(4)
        }
        .frame(width: 167, height: 195)
        .background(.white)
    }
}

#Preview {
    PlainCollectionItem(category: PopularCategory(image_src: "", shopify_collection_id: "", title: "Beef", products: nil))
}
