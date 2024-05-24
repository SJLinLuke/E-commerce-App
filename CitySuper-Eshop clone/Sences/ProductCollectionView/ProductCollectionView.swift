//
//  ProductCollectionView.swift
//  CitySuper-Eshop clone
//
//  Created by LukeLin on 2024/5/24.
//

import SwiftUI

struct ProductCollectionView: View {
    
    @StateObject var VM = ProductCollectionViewModel()
    
    @State var searchText: String = ""
    
    var collectionID: String
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack {
                    Text("Highlight Product")
                        .fontWeight(.bold)
                        .foregroundColor(.vipGold)
                        .padding(.top, 40)
                    
                    ZStack(alignment: .top) {
                        
                        Image("bg_highLight")
                            .resizable()
                            .frame(height: 300)
                            .padding(.top, 5)
                        
                        ProductItem(product: VM.getHighLightProduct(), width: 320, height: 480, isNeedDelete: false)
                            .padding(.top, -20)
                        
                    }
                    .frame(height: 500)
                    
                    HStack {
                        Text("31 results")
                            .font(.subheadline)
                            .fontWeight(.medium)
                            .foregroundColor(.secondary)
                        
                        Spacer()
                        
                        Button {
                            
                        } label: {
                            Text("SORT")
                            Image("dropdown_icon")
                        }
                        .font(.subheadline)
                        .fontWeight(.medium)
                        .foregroundColor(.secondary)
                    }
                    .padding(8)
                    .overlay(alignment: .top) {
                        Rectangle()
                            .fill(.secondary)
                            .frame(height: 0.3)
                    }
                    .overlay(alignment: .bottom) {
                        Rectangle()
                            .fill(.secondary)
                            .frame(height: 0.3)
                    }
                    .background(Color(hex: "F2F2F8"))

                    ProductVGridView(products: [ProductBody(description_html: "", is_favourite: false, shopify_product_id: "", title: "1 Itailian Beef (privious forzen) (300g)", variants: nil, options: nil, logistic_tags: nil, image_src: "", inventory_quantity: 1, compare_at_price: nil, price: "69.99", images: nil, products: nil, similar_products: nil),ProductBody(description_html: "", is_favourite: false, shopify_product_id: "", title: "Itailian Beef (privious forzen) (300g)", variants: nil, options: nil, logistic_tags: nil, image_src: "", inventory_quantity: 1, compare_at_price: nil, price: "69.99", images: nil, products: nil, similar_products: nil),ProductBody(description_html: "", is_favourite: false, shopify_product_id: "", title: "Itailian ef (privious forzen) (300g)", variants: nil, options: nil, logistic_tags: nil, image_src: "", inventory_quantity: 1, compare_at_price: nil, price: "69.99", images: nil, products: nil, similar_products: nil),ProductBody(description_html: "", is_favourite: false, shopify_product_id: "", title: "Itai Beef (privious forzen) (300g)", variants: nil, options: nil, logistic_tags: nil, image_src: "", inventory_quantity: 1, compare_at_price: nil, price: "69.99", images: nil, products: nil, similar_products: nil)], isNeedDelete: false, itemWidth: 180, itemHeight: 280, meetLast: {print("meet")})
                    
                    Spacer()
                }
                .onAppear {
                    VM.fetchCollection(collectionID: collectionID)
                    VM.fetchCollectionProducts(collectionID: collectionID)
                }
                .background(Color(hex:"F7F7F7"))
                .modifier(NavigationModifier(title: "Pork", isHideCollectionsList: true))
                .searchable(text: $searchText, placement: .navigationBarDrawer(displayMode: .always))
            }
        }
        .overlay {
            if VM.isLoading {
                LoadingIndicatiorView()
            }
        }
    }
}

#Preview {
    ProductCollectionView(collectionID: "")
}
