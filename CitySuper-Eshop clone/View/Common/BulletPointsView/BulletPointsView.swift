//
//  ProductDetailBulletPointsView.swift
//  CitySuper-Eshop clone
//
//  Created by LukeLin on 2024/5/21.
//

import SwiftUI

enum UIMode {
    case normal
    case cart
}

struct BulletPointsView: View {
        
    let tags: [LogisticTag]
    var mode: UIMode = .normal
    
    var body: some View {
        VStack(alignment: .leading) {
            ForEach(tags, id: \.self) { tag in
                HStack {
                    let frameSize: CGFloat = mode == .cart ? 15 : 20
                    Image(tag.typeImage)
                        .resizable()
                        .frame(width: frameSize, height: frameSize)
                    
                    Text(mode == .cart ? tag.tag_name : tag.bullet_point ?? "")
                        .font(mode == .cart ? .caption : .subheadline)
                        .foregroundColor(.gray)
                }
                .padding(mode == .cart ? .bottom : .vertical)
            }
        }
    }
}

#Preview {
    BulletPointsView(tags: [LogisticTag(bullet_point: "test_bullet_point", tag_name: "test_tag_name", type: "")])
}
