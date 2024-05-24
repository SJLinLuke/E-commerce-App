//
//  ProductDetailBulletPointsView.swift
//  CitySuper-Eshop clone
//
//  Created by LukeLin on 2024/5/21.
//

import SwiftUI

struct ProductDetailBulletPointsView: View {
        
    let tags: [LogisticTag]
    
    var body: some View {
        VStack(alignment: .leading) {
            ForEach(tags, id: \.self) { tag in
                HStack {
                    Image(tag.typeImage)
                        .resizable()
                        .frame(width: 20, height: 20)        
                    
                    Text(tag.bullet_point ?? "")
                        .font(.subheadline)
                        .foregroundColor(.gray)
                }
                .padding(.vertical)
            }
        }
    }
}

#Preview {
    ProductDetailBulletPointsView(tags: [LogisticTag(bullet_point: "test_bullet_point", tag_name: "test_tag_name", type: "")])
}
