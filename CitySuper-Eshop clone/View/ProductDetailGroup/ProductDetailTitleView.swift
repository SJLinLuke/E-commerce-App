//
//  ProductDetailTitleView.swift
//  CitySuper-Eshop clone
//
//  Created by LukeLin on 2024/5/21.
//

import SwiftUI

struct ProductDetailTitleView: View {
    
    @StateObject var VM = ProductDetailViewModel.shared
    
    var body: some View {
        HStack(alignment: .top) {
            Text(VM.product.title)
                .font(.system(size: 18))
                .fontWeight(.bold)
            
            Spacer()
            
            Button {
                print("tap share!")
            } label: {
                Image("share_icon")
            }
            .padding(.leading, 20)
            
        }
        .padding(EdgeInsets(top: 15, leading: 15, bottom: 0, trailing: 20))
    }
}

#Preview {
    ProductDetailTitleView()
}
