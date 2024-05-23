//
//  ProductDetailBulletPointsView.swift
//  CitySuper-Eshop clone
//
//  Created by LukeLin on 2024/5/21.
//

import SwiftUI

struct ProductDetailBulletPointsView: View {
    
    @StateObject var VM = ProductDetailViewModel.shared
    
    var body: some View {
        VStack {
            ForEach(VM.product?.logistic_tags ?? [], id: \.self) { tag in
                HStack {
                    Image(VM.logisticTypeImage(type: tag.type))
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
    ProductDetailBulletPointsView()
}
