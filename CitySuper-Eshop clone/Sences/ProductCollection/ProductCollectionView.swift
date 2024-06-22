//
//  ProductCollectionView.swift
//  CitySuper-Eshop clone
//
//  Created by LukeLin on 2024/5/24.
//

import SwiftUI

struct ProductCollectionView: View {
    
    @StateObject private var VM       = ProductCollectionViewModel()
    @StateObject private var searchVM = SearchListViewModel.shared
    
    @State private var isShowBackToTop: Bool = false
    @State private var isShowResult   : Bool = false

    var collectionID: String
    
    var body: some View {
        NavigationStack {
            ScrollViewReader { scrollView in
                ScrollView {
                    VStack {
                        Text("Highlight Product")
                            .fontWeight(.bold)
                            .foregroundColor(.vipGold)
                            .padding(.top, 40)
                            .id("top")
                        
                        ZStack(alignment: .top) {
                            
                            Image("bg_highLight")
                                .resizable()
                                .frame(height: 300)
                                .padding(.top, 5)
                            
                            ProductItem(width: 320, height: 480, isNeedDelete: false, product: VM.getHighLightProduct())
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
                    .modifier(NavigationModifier(navTilte: VM.navTitle, isHideCollectionsList: true))
                    .modifier(ScrollToTopModifier(isShowBackToTop: $isShowBackToTop))
                }
                .modifier(searchModifier(isShowResult: $isShowResult, searchText: $searchVM.searchText))
                .searchable(text: $searchVM.searchText, placement: .navigationBarDrawer(displayMode: .always), prompt: Constants.searchPrompt)
                .onSubmit(of: .search, {
                    isShowResult.toggle()
                })
                .overlay(alignment: .bottomTrailing) {
                    Button {
                        withAnimation {
                            scrollView.scrollTo("top")
                        }
                    } label: {
                        BackToTopButton(isShow: isShowBackToTop)
                    }
                }
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
