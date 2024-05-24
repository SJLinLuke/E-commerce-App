//
//  ProductDetailView.swift
//  CitySuper-Eshop clone
//
//  Created by LukeLin on 2024/5/21.
//

import SwiftUI

struct ProductDetailView: View {
    
    @StateObject var VM = ProductDetailViewModel.shared
    
    @State var searchText: String        = ""
    @State var htmlFrameHeight: CGFloat  = .zero
    @State var isGalleryDetailShow: Bool = false
    
    var shopifyID: String
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack {
                    ProductDetailImageGalleryView(isGalleryDetailShow: $isGalleryDetailShow, images: VM.product?.images ?? [])
                    
                    GeometryReader(content: { geometry in
                        Spacer()
                            .frame(width: geometry.size.width - 15, height: 1)
                            .overlay(alignment: .trailing) {
                                FavouriteButton(isFavourite: true, width: 40, height: 40)
                            }
                            .padding(.top, -8)
                    })
                    
                    ProductDetailTitleView()
                    
                    ProductDetailTagsView()
                    
                    VStack(alignment: .leading) {
                        Rectangle()
                            .fill(.secondary)
                            .frame(height: 0.5)
                        
                        ProductDetailPriceView()
                        
                        Rectangle()
                            .fill(.secondary)
                            .frame(height: 0.5)
                        
                        ProductDetailBulletPointsView()
                        
                        Rectangle()
                            .fill(.secondary)
                            .frame(height: 0.5)
                        
                        HTMLLoaderView(htmlFrameHeight: $htmlFrameHeight,
                                       htmlString: VM.product?.description_html ?? "")
                        .frame(height: htmlFrameHeight)
                    }
                    .padding()
                    
                    ProductDetailMoreProductsView(title: "Related Products",
                                                  products: VM.relatedProducts,
                                                  meetLast: {
                        VM.fetchRelatedProduct(shopifyID: shopifyID)
                    })
                    
                    Spacer()
                        .frame(height: 0)
                    
                    ProductDetailMoreProductsView(title: "Similar Products",
                                                  products: VM.similarProducts,
                                                  meetLast: {
                        VM.fetchSimilarProduct(shopifyID: shopifyID)
                    })
                }
                .onAppear {
                    VM.fetchProduct(shopifyID: shopifyID)
                }
            }
            .overlay {
                if VM.isLoading {
                    LoadingIndicatiorView()
                }
            }
            .modifier(NavigationModifier(isHideCollectionsList: true))
            .searchable(text: $searchText, placement: .navigationBarDrawer(displayMode: .always))
        }
    }
}

#Preview {
    ProductDetailView(shopifyID: "")
}
