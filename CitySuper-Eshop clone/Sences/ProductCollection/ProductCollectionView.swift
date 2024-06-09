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
    var navTitle    : String
    
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
                        Text("\(VM.productsTotal) results")
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
                        SeperateLineView()
                    }
                    .overlay(alignment: .bottom) {
                        SeperateLineView()
                    }
                    .background(Color(hex: "F2F2F8"))

                    ProductVGridView(products: VM.collectionProducts, isNeedDelete: false, itemWidth: 180, itemHeight: 280, meetLast: {
                        VM.fetchCollectionProducts(collectionID: collectionID)
                    })
                    
                    Spacer()
                }
                .onAppear {
                    VM.fetchCollection(collectionID: collectionID)
                    VM.fetchCollectionProducts(collectionID: collectionID)
                }
                .background(Color(hex:"F7F7F7"))
                .modifier(NavigationModifier(navTilte: navTitle, isHideCollectionsList: true))
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
    ProductCollectionView(collectionID: "", navTitle: "Pork")
}
