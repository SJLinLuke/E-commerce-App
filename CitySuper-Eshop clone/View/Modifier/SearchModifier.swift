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
                    SearchList()
                }
            } else {
                content
            }
        }
    }
}

struct SearchListCell: View {
    
    let text : Text
    let icon : String
    
    var isAccessoryIcon: Bool = true
    
    var body: some View {
        HStack {
            if !icon.isEmpty {
                Image(icon)
                    .resizable()
                    .frame(width: 20, height: 18)
            }
            
            text
                .padding(.leading, 10)
                .lineLimit(1)
            
            Spacer()
            
            if isAccessoryIcon {
                Image("search_arrowright_icon")
            }
        }
        .foregroundColor(.secondary)
        .padding()
    }
}

struct SearchList: View {
    
    @StateObject var VM = SearchListViewModel.shared
    
    var body: some View {
        ScrollView {
            VStack(spacing: 0) {
                
                if !VM.brands.isEmpty {
                    SearchHeader(title: "Brand")
                        .background(Color(hex: "F2F2F2"))
                    
                    ForEach(VM.brands, id: \.self) { brand in
                        SearchListCell(text: Text(brand), icon: "search_shop_icon")
                            .overlay(alignment: .bottom) {
                                if brand != VM.brands.last {
                                    SeperateLineView(color: .black)
                                }
                            }
                    }
                }
                
                if !VM.collections.isEmpty {
                    SearchHeader(title: "Keyword Suggestions")
                        .background(Color(hex: "F2F2F2"))
                    
                    ForEach(VM.collections, id: \.self) { collection in
                        SearchListCell(text: Text(collection.title), icon: "search_icon")
                            .overlay(alignment: .bottom) {
                                if collection != VM.collections.last {
                                    SeperateLineView(color: .black)
                                }
                            }
                    }
                }
                
                if !VM.product_collections.isEmpty {
                    SearchHeader(title: "Keyword Under Categories")
                        .background(Color(hex: "F2F2F2"))
                    
                    ForEach(VM.product_collections, id: \.self) { collection in
                        SearchListCell(text: Text(collection.title), icon: "search_icon")
                            .overlay(alignment: .bottom) {
                                if collection != VM.product_collections.last {
                                    SeperateLineView(color: .black)
                                }
                            }
                    }
                }
                
                SeperateLineView(color: Color(hex: "F2F2F2"), height: 20)
                
                HStack {
                    SearchListCell(text:
                                    Text("Show all results for ") +
                                   Text("\"\(VM.searchText)\"").bold().foregroundColor(.gray)
                                   , icon: "", isAccessoryIcon: false)
                    if VM.isLoading {
                        ProgressView()
                            .padding(.trailing)
                    }
                }
                
            }
        }
    }
}


#Preview {
    SearchList()
}












struct SuggestionView: View {
    
    @StateObject var VM = SuggestionViewModel.shared
    
    var body: some View {
        ScrollView {
            VStack {
                SearchHeader(title: "Recent Searches", buttonTitle: "Clean all") {
                    VM.historyKeywords = []
                    VM.clearHistoryKeyword()
                }
                
                SearchTagsView(keywords: VM.historyKeywords)
                
                SearchHeader(title: "Hot Keywords")
                
                SearchTagsView(keywords: VM.hotKeywords)
                
                SearchHeader(title: "Recommendation Collections")
                
                SearchRecommendationView(recommendationCollections: VM.recommendKeywords)
            }
            .task {
                VM.fetchSuggestion()
            }
        }
        .overlay {
            if VM.isLoading {
                LoadingIndicatiorView()
            }
        }
        .background(Color(hex: "F2F2F2"))
        .padding(.top)
    }
}



struct SearchHeader: View {
    
    let title       : String
    var buttonTitle : String?
    var buttonAction: (() -> Void)?
    
    var body: some View {
        HStack {
            Text(title)
                .font(.system(size: 16))
                .fontWeight(.bold)
                .foregroundColor(Color(hex: "777777"))
            
            Spacer()
            
            if let buttonTitle = buttonTitle {
                Button(action: buttonAction ?? {})  {
                    Text(buttonTitle)
                        .font(.callout)
                        .foregroundColor(.secondary)
                }
            }
        }
        .padding()
    }
}

struct SearchTagCell: View {
    
    let title: String
    
    var body: some View {
        HStack {
            Text(title)
            Image("search_arrowright_icon")
                .resizable()
                .frame(width: 6, height: 8)
        }
        .font(.system(size: 14))
        .frame(height: 28)
        .padding(.horizontal, 5)
        .foregroundColor(.secondary)
        .overlay {
            RoundedRectangle(cornerRadius: 4)
                .stroke(.gray ,lineWidth: 1)
        }
    }
}

struct SearchTagsView: View {
    
    @StateObject var searchVM = SearchListViewModel.shared
    
    @State private var isShowMore: Bool = false
    
    let keywords: [String]
    
    private let screenWidth = UIScreen.main.bounds.width * 0.95
    
    var body: some View {
        VStack {
            FlexibleView(availableWidth: screenWidth, data: keywords, spacing: 5, alignment: .leading, isShowMore: isShowMore ) {
                title in
                SearchTagCell(title: title)
                    .onTapGesture {
                        searchVM.searchText = title
                    }
            }
            
            if !keywords.isEmpty {
                Button {
                    DispatchQueue.main.async { isShowMore.toggle() }
                } label: {
                    HStack {
                        Text(isShowMore ? "Show less" : "Show more")
                        Image(isShowMore ?
                              "search_arrowup_icon" : "search_arrowdown_icon")
                    }
                    .font(.system(size: 14))
                    .foregroundColor(Color(hex: "777777"))
                }
                .padding(.top)
            }
            
        }
    }
}

struct SearchRecommendationView: View {
    
    let recommendationCollections: [recommendKeywords]
    
    private let width = UIScreen.main.bounds.width / 2.25
    
    var body: some View {
        LazyVGrid(columns: [GridItem(.adaptive(minimum: width, maximum: width))]) {
            ForEach(recommendationCollections) { collection in
                NavigationLink {
                    ProductCollectionView(collectionID: collection.shopify_storefront_id)
                } label: {
                    RemoteImageView(url: collection.image_src ?? "", placeholder: .common)
                        .aspectRatio(contentMode: .fit)
                        .frame(height: 170)
                }
            }
        }
        .padding(.bottom)
    }
}
