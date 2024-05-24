//
//  ProductDetailTagsView.swift
//  CitySuper-Eshop clone
//
//  Created by LukeLin on 2024/5/21.
//

import SwiftUI

struct ProductDetailTagsView: View {
        
    let tags: [LogisticTag]
        
    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack {
                ForEach(tags, id: \.self) { tag in
                    HStack {
                        Image(tag.typeImage)
                            .resizable()
                            .frame(width: 15, height: 15)
                        
                        Text(tag.tag_name)
                            .font(.subheadline)
                            .foregroundColor(.themeGreen2)
                    }
                    .padding(.horizontal, 10)
                    .frame(height: 30)
                    .overlay {
                        RoundedRectangle(cornerRadius: 5)
                            .stroke(Color.themeGreen2, lineWidth: 1.5)
                    }
                }
            }
        }
        .padding(.leading)
        .padding(.bottom, -10)
    }
}

#Preview {
    ProductDetailTagsView(tags: [LogisticTag(bullet_point: "test_bullet_point", tag_name: "test_tag_name", type: "")])
}
