//
//  SearchResultProductsSection.swift
//  CitySuper-Eshop clone
//
//  Created by LukeLin on 2024/6/21.
//

import SwiftUI

struct SearchResultProductsSection: View {
    
    @StateObject var VM       = SearchResultViewModel.shared
    @StateObject var searchVM = SearchListViewModel.shared
    
    @State var currentSortKey: String = "Score"
    @State var isShowSort: Bool = false
    
    private let edgeInsets = EdgeInsets(top: 7, leading: 15, bottom: 7, trailing: 15)

    var body: some View {
        HStack {
            if VM.totalCountNum > 0 {
                Text("\(VM.totalCountNum) product(s) for ") +
                Text("\"\(searchVM.searchText)\"").bold()
            } else {
                Text("No result found.\nShowing top popular products for you...")
                    .font(.system(size: 14))
            }
            
            Spacer()
            Button {
                isShowSort.toggle()
            } label: {
                HStack {
                    Text("Sort")
                    Image("search_arrowdown_icon")
                }
                .padding(edgeInsets)
                .overlay {
                    RoundedRectangle(cornerRadius: 5)
                        .stroke(lineWidth: 1)
                }
            }
        }
        .task {
            if VM.products.isEmpty {
                VM.fetchKeywordProducts(keyword: searchVM.searchText, collectionID: "")
            }
        }
        .padding(10)
        .foregroundColor(Color(hex: "777777"))
        .sheet(isPresented: $isShowSort) {
            SearchResultSortButtomSheet(currentSortKey: $currentSortKey, isShowSortButtonSheet: $isShowSort)
        }
        
        ProductVGridView(products: VM.products, isNeedDelete: false, itemWidth: 182, itemHeight: 270, meetLast: {
            VM.fetchKeywordProducts(keyword: searchVM.searchText, collectionID: "")
        })
    }
}

#Preview {
    SearchResultProductsSection()
}
