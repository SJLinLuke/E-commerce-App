//
//  ProductDetailTagsView.swift
//  CitySuper-Eshop clone
//
//  Created by LukeLin on 2024/5/21.
//

import SwiftUI

struct ProductDetailTagsView: View {
    
    @StateObject var VM = ProductDetailViewModel.shared
        
    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            ForEach(VM.product.logistic_tags ?? [], id: \.self) { tag in
                HStack {
                    Image(VM.logisticTypeImage(type: tag.type))
                        .resizable()
                        .frame(width: 20, height: 15)
                    
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
        .padding(.leading)
        .padding(.bottom, -10)
    }
}

#Preview {
    ProductDetailTagsView()
}
