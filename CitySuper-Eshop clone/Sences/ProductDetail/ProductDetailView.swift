//
//  ProductDetailView.swift
//  CitySuper-Eshop clone
//
//  Created by LukeLin on 2024/5/21.
//

import SwiftUI

struct ProductDetailView: View {
    
    @StateObject var VM = ProductDetailViewModel()
    
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
                    .padding(EdgeInsets(top: 15, leading: 10, bottom: 0, trailing: 20))
                    
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack {
                            Image("deliveryonly_icon")
                                .resizable()
                                .frame(width: 20, height: 15)
                            
                            Text("Dekivery Only")
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
                    .padding(.leading)
                    .padding(.bottom, -10)
                    
                    VStack(alignment: .leading) {
                        Rectangle()
                            .fill(.secondary)
                            .frame(height: 0.5)
                        
                        HStack {
                            Text("$100,000.00")
                                .font(.title3)
                                .fontWeight(.bold)
                            //compare price
                            Text("$999")
                                .font(.caption)
                                .strikethrough()
                                .foregroundColor(.secondary)
                            
                            Spacer()
                            
                            SoldOutButton(width: 53, height: 30)
                        }
                        .padding(.vertical, 5)
                        
                        Rectangle()
                            .fill(.secondary)
                            .frame(height: 0.5)
                        
                        VStack {
                            HStack {
                                Image("deliveryonly_icon")
                                    .resizable()
                                    .frame(width: 20, height: 15)
                                
                                Text("Only avaliable for delivery")
                                    .font(.subheadline)
                                    .foregroundColor(.gray)
                            }
                            .padding(.vertical)
                        }
                                                
                        Rectangle()
                            .fill(.secondary)
                            .frame(height: 0.5)
                        
                        Text("Keep refrigerated \n *Photo for reference only.")
                            .padding()
                            .lineSpacing(10)
                        
                    }
                    .padding()
                    
                    CollectionNormalLayoutView_Normal( collectionNormalLayout: CollectionNormalLayoutModel(title: "Related Product", layout: "", products: [ProductBody(description_html: "", is_favourite: false, shopify_product_id: "", title: "1 Itailian Veal Tongue [Previous Forzen] (300g)", variants: nil, options: nil, logistic_tags: nil, image_src: "", inventory_quantity: 0, compare_at_price: "40", price: "69.00", images: nil, products: nil, similar_products: nil)], shopify_collection_id: ""), itemWidth: 175, itemHeight: 270, isRelatedSimilar: true)
                        .background(Color(hex: "F2F2F2"))
                    
                    Spacer()
                        .frame(height: 0)
                    
                    CollectionNormalLayoutView_Normal( collectionNormalLayout: CollectionNormalLayoutModel(title: "Similar Product", layout: "", products: [ProductBody(description_html: "", is_favourite: false, shopify_product_id: "", title: "1 Itailian Veal Tongue [Previous Forzen] (300g)", variants: nil, options: nil, logistic_tags: nil, image_src: "", inventory_quantity: 0, compare_at_price: "40", price: "69.00", images: nil, products: nil, similar_products: nil)], shopify_collection_id: ""), itemWidth: 175, itemHeight: 270, isRelatedSimilar: true)
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
