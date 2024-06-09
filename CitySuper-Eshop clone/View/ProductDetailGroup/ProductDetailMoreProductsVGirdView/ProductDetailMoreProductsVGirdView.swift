//
//  ProductDetailMoreProductsVGirdView.swift
//  CitySuper-Eshop clone
//
//  Created by LukeLin on 2024/5/28.
//

import SwiftUI

struct ProductDetailMoreProductsVGirdView: View {
     
    @StateObject var VM = ProductDetailMoreProductsVGirdViewModel()
    
    @State var searchText: String = ""
    
    let navTitle : String
    let shopifyID: String
    
    var body: some View {
        NavigationStack {
            VStack {
                ScrollView {
                    ProductVGridView(products: VM.moreProducts, isNeedDelete: false, itemWidth: 180, itemHeight: 280, meetLast: {
                        VM.fetchMoreProducts(navTitle, id: shopifyID)
                    })
                }
            }
            .modifier(NavigationModifier(navTilte: navTitle, isHideCollectionsList: true))
            .searchable(text: $searchText, placement: .navigationBarDrawer(displayMode: .always))
            .onAppear {
                VM.fetchMoreProducts(navTitle, id: shopifyID)
            }
        }
    }
}

#Preview {
    ProductDetailMoreProductsVGirdView(navTitle: "Test Title", shopifyID: "")
}
