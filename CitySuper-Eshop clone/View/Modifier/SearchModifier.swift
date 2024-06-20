//
//  SearchModifier.swift
//  CitySuper-Eshop clone
//
//  Created by LukeLin on 2024/6/16.
//

import SwiftUI

struct searchModifier: ViewModifier {
    
    @Environment(\.isSearching) var isSearching
    
    @Binding var searchText: String
    
    func body(content: Content) -> some View {
        ZStack {
            if isSearching {
                if searchText.isEmpty {
                    SuggestionView()
                } else {
                    SearchListView()
                }
            } else {
                content
            }
        }
    }
}

enum SearchResultType {
    case products
    case collections
}

struct SearchResultHeaderView: View {
        
    @Binding var currentSelected: SearchResultType
 
    private let edgeInsets = EdgeInsets(top: 7, leading: 15, bottom: 7, trailing: 15)
    
    var body: some View {
        HStack {
            Button {
                currentSelected = .products
            } label: {
                Text("Products")
                    .padding(edgeInsets)
                    .overlay {
                        RoundedRectangle(cornerRadius: 5)
                            .stroke(.secondary ,lineWidth: 1)
                    }
                    .foregroundColor(currentSelected == .products ? .white : Color(hex: "777777") )
                    .background(currentSelected == .products ? Color(hex: "777777") : .white)
                    .cornerRadius(5)
                    .padding(.leading)
            }
            
            Button {
                currentSelected = .collections
            } label: {
                Text("Collections")
                    .padding(edgeInsets)
                    .overlay {
                        RoundedRectangle(cornerRadius: 5)
                            .stroke(lineWidth: 1)
                    }
                    .foregroundColor(currentSelected == .collections ? .white : Color(hex: "777777") )
                    .background(currentSelected == .collections ? Color(hex: "777777") : .white)
                    .cornerRadius(5)
            }
            Spacer()
        }
        .padding(.vertical)
        .background(Color(hex: "F2F2F2"))
        .padding(.top, 1)
    }
}

struct SearchResult: View {
    
    @StateObject var searchVM = SearchListViewModel.shared
    @StateObject var VM       = SearchResultViewModel()
    
    private let edgeInsets = EdgeInsets(top: 7, leading: 15, bottom: 7, trailing: 15)

    var keyword: String = ""
    var collectionID: String = ""
    
    var body: some View {
        VStack {
            ScrollView {
               
                SearchResultHeaderView(currentSelected: $VM.currcntSelected)
                
                if VM.isSelectProducts {
                    HStack {
                        Text("\(VM.totalCountNum) product(s) for ") +
                        Text("\"\(keyword)\"").bold()
                        Spacer()
                        Button {
                            
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
                    .padding(.horizontal)
                    .foregroundColor(Color(hex: "777777"))
                    
                    ProductVGridView(products: VM.products, isNeedDelete: false, itemWidth: 182, itemHeight: 270, meetLast: {
                        VM.fetchKeywordProducts(keyword: keyword, collectionID: collectionID)
                    })
                }
                
                if VM.isSelectCollections {
                    
                }
                
                Spacer()
            }
        }
        .overlay {
            if VM.isLoading {
                LoadingIndicatiorView()
            }
        }
        .onAppear {
            searchVM.searchText = keyword
            VM.fetchKeywordProducts(keyword: keyword, collectionID: collectionID)
        }
        .modifier(NavigationModifier(isHideCollectionsList: true))
        .modifier(searchModifier(searchText: $searchVM.searchText))
        .searchable(text: $searchVM.searchText, placement: .navigationBarDrawer(displayMode: .always), prompt: Constants.searchPrompt)
    }
}


#Preview {
    SearchResult()
        .environmentObject(CartEnvironment())
}
