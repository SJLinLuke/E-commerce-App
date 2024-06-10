//
//  ProductDetailView.swift
//  CitySuper-Eshop clone
//
//  Created by LukeLin on 2024/5/21.
//

import SwiftUI

struct ProductDetailView: View {
    
    @StateObject var VM = ProductDetailViewModel()
    
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
                    
                    ProductDetailTitleView(title: VM.product?.title ?? "")
                    
                    ProductDetailTagsView(tags: VM.product?.logistic_tags ?? [])
                    
                    VStack(alignment: .leading) {
                        
                        SeperateLineView()
                        
                        ProductDetailPriceView(price: VM.product?.price ?? "0")
                        
                        SeperateLineView()
                        
                        BulletPointsView(tags: VM.product?.logistic_tags ?? [])
                        
                        SeperateLineView()
                        
                        HTMLLoaderView(htmlFrameHeight: $htmlFrameHeight,
                                       htmlString: VM.product?.description_html ?? "",
                                       source: Constants.productDetail_html_source)
                        .frame(height: htmlFrameHeight)
                    }
                    .padding()
                    
                    if !VM.relatedProducts.isEmpty {
                        ProductDetailMoreProductsView(title: "Related Products",
                                                      shopifyID: shopifyID,
                                                      products: VM.relatedProducts,
                                                      meetLast: {
                            VM.fetchRelatedProduct(shopifyID: shopifyID)
                        })
                        
                    }
                    
                    Spacer()
                        .frame(height: 0)
                    
                    if !VM.similarProducts.isEmpty {
                        ProductDetailMoreProductsView(title: "Similar Products", 
                                                      shopifyID: shopifyID,
                                                      products: VM.similarProducts,
                                                      meetLast: {
                            VM.fetchSimilarProduct(shopifyID: shopifyID)
                        })
                    }
                }
                .task {
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
