//
//  ProductDetailView.swift
//  CitySuper-Eshop clone
//
//  Created by LukeLin on 2024/5/21.
//

import SwiftUI

struct ProductDetailView: View {
    
    @StateObject var VM = ProductDetailViewModel.shared
    
    @State var searchText: String = ""
    
    var shopifyID: String
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack {
                    
                    Rectangle()
                        .frame(height: 400)
                    
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
                        
                        Text("Keep refrigerated \n *Photo for reference only.")
                            .padding()
                            .lineSpacing(10)
                        
                    }
                    .padding()
                    
                    CollectionNormalLayoutView_Normal( collectionNormalLayout: CollectionNormalLayoutModel(title: "Related Product", layout: "", products: VM.product.products ?? [], shopify_collection_id: ""), itemWidth: 175, itemHeight: 270, isRelatedSimilar: true)
                        .background(Color(hex: "F2F2F2"))
                    
                    Spacer()
                        .frame(height: 0)
                    
                    CollectionNormalLayoutView_Normal( collectionNormalLayout: CollectionNormalLayoutModel(title: "Similar Product", layout: "", products: VM.product.similar_products ?? [], shopify_collection_id: ""), itemWidth: 175, itemHeight: 270, isRelatedSimilar: true)
                        .background(Color(hex: "F2F2F2"))
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
