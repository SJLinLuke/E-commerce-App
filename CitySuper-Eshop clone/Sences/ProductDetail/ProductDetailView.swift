//
//  ProductDetailView.swift
//  CitySuper-Eshop clone
//
//  Created by LukeLin on 2024/5/21.
//

import SwiftUI

struct ProductDetailView: View {
    
    @StateObject private var VM       = ProductDetailViewModel()
    @StateObject private var searchVM = SearchListViewModel.shared
    
    @State var htmlFrameHeight    : CGFloat = .zero
    @State var isGalleryDetailShow: Bool = false
    @State var isShowBackToTop    : Bool = false
    
    var shopifyID: String
    
    var body: some View {
        NavigationStack {
            ScrollViewReader { scrollView in
                ScrollView {
                    VStack {
                        ProductDetailImageGalleryView(isGalleryDetailShow: $isGalleryDetailShow, images: VM.product?.images ?? [])
                            .id("top")
                        
                        GeometryReader(content: { geometry in
                            Spacer()
                                .frame(width: geometry.size.width - 15, height: 1)
                                .overlay(alignment: .trailing) {
                                    FavouriteButton(isFavourite: $VM.isFavourite,
                                                    product: VM.product ?? ProductBody.mockData(), width: 40, height: 40)
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
                    .modifier(ScrollToTopModifier(isShowBackToTop: $isShowBackToTop))
                    .task {
                        VM.fetchProduct(shopifyID: shopifyID)
                    }
                }
                .modifier(searchModifier(searchText: $searchVM.searchText))
                .modifier(NavigationModifier(isHideCollectionsList: true))
                .overlay {
                    if VM.isLoading {
                        LoadingIndicatiorView()
                    }
                }
                .overlay(alignment: .bottomTrailing) {
                    Button {
                        withAnimation {
                            scrollView.scrollTo("top")
                        }
                    } label: {
                        BackToTopButton(isShow: isShowBackToTop)
                    }
                }
                .searchable(text: $searchVM.searchText, placement: .navigationBarDrawer(displayMode: .always), prompt: Constants.searchPrompt)
            }
        }
    }
}

#Preview {
    ProductDetailView(shopifyID: "")
        .environmentObject(CartEnvironment())
}
