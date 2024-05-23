//
//  GalleryImageDetailView.swift
//  CitySuper-Eshop clone
//
//  Created by LukeLin on 2024/5/23.
//

import SwiftUI

struct ProductDetailIGalleryImageDetailView: View {
    
    @Binding var selectedIndex: Int
    @Binding var isGalleryDetailShow: Bool
    
    var images: [ProductImage]
    
    var body: some View {
        ZStack {
            Color.black
                .ignoresSafeArea(.all)
            TabView(selection: $selectedIndex) {
                if images.isEmpty {
                    Image("common_placeholder")
                        .resizable()
                }
                ForEach(images.indices, id: \.self) { index in
                    RemoteImageView(url: images[index].src ?? "",
                                    placeholder: .common)
                    .tag(index)
                    .aspectRatio(contentMode: .fit)
                    .onTapGesture {
                        isGalleryDetailShow = true
                    }
                }
            }
            .tabViewStyle(.page(indexDisplayMode: .always))
        }
        .overlay(alignment: .topTrailing) {
            Button {
                isGalleryDetailShow = false
            } label: {
                Text("Close")
                    .foregroundColor(.white)
            }
            .padding()
        }
    }
}

#Preview {
    ProductDetailIGalleryImageDetailView(selectedIndex: .constant(0), isGalleryDetailShow: .constant(true), images: [ProductImage(src: "", width: 1000, height: 100)])
}
