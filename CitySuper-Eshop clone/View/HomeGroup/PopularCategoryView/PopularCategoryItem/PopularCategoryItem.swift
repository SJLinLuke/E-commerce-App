//
//  PopularCategoryItem.swift
//  CitySuper-Eshop clone
//
//  Created by LukeLin on 2024/5/11.
//

import SwiftUI

struct PopularCategoryItem: View {
    
    var imageSrc: String
    var title   : String
    
    var body: some View {
        VStack {
            RemoteImageView(url: imageSrc, placeholder: .common)
                .frame(width: 55, height: 55)
                .cornerRadius(50)

            Spacer()
                .frame(height: 10)
            
            Text(title)
                .font(.system(size: 10))
                .foregroundColor(.black)
        }
        .padding(.top, 10)
    }
}

#Preview {
    PopularCategoryItem(imageSrc: "https://mobilestouat.citysuper.com.hk/eshop/collections/collections_icon_02-Pork62d7a55298542.png", title: "Pork")
}
