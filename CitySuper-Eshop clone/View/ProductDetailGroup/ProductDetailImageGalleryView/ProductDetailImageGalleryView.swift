//
//  ProductDetailImageGalleryView.swift
//  CitySuper-Eshop clone
//
//  Created by LukeLin on 2024/5/22.
//

import SwiftUI

struct ProductDetailImageGalleryView: View {
    
    @State var selectedIndex: Int = 0
    @State var height: Double = 400
    
    @Binding var isGalleryDetailShow: Bool
    
    var images: [ProductImage]
    
    var body: some View {
        TabView(selection: $selectedIndex) {
            if images.isEmpty {
                Image("common_placeholder")
                    .resizable()
            }
            ForEach(images.indices, id: \.self) { index in
                GeometryReader(content: { geometry in
                    RemoteImageView(url: images[index].src ?? "",
                                    placeholder: .common)
                    .tag(index)
                    .onAppear {
                        self.height = geometry.size.width
                    }
                    .onTapGesture {
                        isGalleryDetailShow = true
                    }
                })
                
            }
        }
        .frame(height: self.height)
        .tabViewStyle(.page(indexDisplayMode: .always))
        .fullScreenCover(isPresented: $isGalleryDetailShow){
            ProductDetailIGalleryImageDetailView(selectedIndex: $selectedIndex, 
                                                 isGalleryDetailShow: $isGalleryDetailShow,
                                                 images: images)
                .background(.black)
        }
    }
}

#Preview {
    ProductDetailImageGalleryView(isGalleryDetailShow: .constant(false), images: [ProductImage(src: "", width: 0, height: 0)])
}
