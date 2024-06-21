//
//  SearchModifier.swift
//  CitySuper-Eshop clone
//
//  Created by LukeLin on 2024/6/16.
//

import SwiftUI

struct searchModifier: ViewModifier {
    
    @Environment(\.isSearching) var isSearching
    
    @Binding var isShowResult: Bool
    @Binding var searchText  : String
    
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
        .navigationDestination(isPresented: $isShowResult) {
            SearchResultView(keyword: searchText)
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

struct SearchResultView: View {
    
    @StateObject var searchVM = SearchListViewModel.shared
    @StateObject var VM       = SearchResultViewModel()
    
    @State private var isShowResult: Bool = false

    private let edgeInsets = EdgeInsets(top: 7, leading: 15, bottom: 7, trailing: 15)

    var keyword     : String = ""
    var collectionID: String = ""
    
    var body: some View {
        ScrollView {
            VStack(spacing: 0) {
               
                SearchResultHeaderView(currentSelected: $VM.currcntSelected)
                
                if VM.isSelectProducts {
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
                        VM.fetchKeywordProducts(keyword: searchVM.searchText, collectionID: collectionID)
                    }
                    .padding(10)
                    .foregroundColor(Color(hex: "777777"))
                    
                    ProductVGridView(products: VM.products, isNeedDelete: false, itemWidth: 182, itemHeight: 270, meetLast: {
                        VM.fetchKeywordProducts(keyword: searchVM.searchText, collectionID: collectionID)
                    })
                }
                
                if VM.isSelectCollections {
                    VStack(spacing: 0) {
                        
                        SearchHeaderView(text:
                                            Text("\(VM.collectionList.count) colleciton(s) for ") + Text("\"\(searchVM.searchText)\"").bold(), titleFont: .system(size: 16), titleFontWeight: .regular, buttonTitle: VM.isListShowMore ? "Show less" : "Show all") {
                            VM.isListShowMore.toggle()
                        }
                                            .overlay(alignment: .bottom) {
                                                SeperateLineView(color: Color(hex: "F7F7F7"), height: 2)
                                            }
                        
                        if !VM.collectionList.isEmpty {

                            ForEach(VM.getList(), id: \.self) { collection in
                                NavigationLink { ProductCollectionView(collectionID: collection.shopify_storefront_id ?? "") } label: {
                                    SearchListCell(text: Text(collection.title), imageSrc: collection.image_src ?? "")
                                        .padding(.vertical, -2)
                                        .overlay(alignment: .bottom) {
                                            SeperateLineView(color: .black)
                                        }
                                }
                            }
                            
                        }
                        
                        
                        SearchHeaderView(text:
                                            Text("\(VM.collectionTags.count) products(s) contain in below collection(s)"), titleFont: .system(size: 16), titleFontWeight: .regular)
                        
                        if !VM.collectionTags.isEmpty {
                            FlexibleView(availableWidth: UIScreen.main.bounds.width * 0.95, data: VM.collectionTags, spacing: 5, alignment: .leading, isShowMore: true) { collection in
                                SearchTagCell(title: collection.title)
                            }
                            
                        }
                        
                    }
                    .task {
                        VM.fetchKeywordList(keyword: searchVM.searchText)
                        VM.fetchKeywordCollection(keyword: searchVM.searchText)
                    }
                    
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
        }
        .modifier(NavigationModifier(isHideCollectionsList: true))
        .searchable(text: $searchVM.searchText, placement: .navigationBarDrawer(displayMode: .always), prompt: Constants.searchPrompt)
        .onSubmit(of: .search) {
//            self.keyword = searchVM.searchText
            VM.initConfig()
            VM.fetchKeywordProducts(keyword: searchVM.searchText)
            VM.fetchKeywordList(keyword: searchVM.searchText)
            VM.fetchKeywordCollection(keyword: searchVM.searchText)
        }
    }
}


#Preview {
    SearchResultView()
        .environmentObject(CartEnvironment())
}
