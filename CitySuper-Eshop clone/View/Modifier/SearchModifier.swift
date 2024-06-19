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
                    SearchView()
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
    
    let title: String
    let icon : String
    
    var isShowArrow: Bool = true
    
    var body: some View {
        HStack {
            Image(icon)
                .resizable()
                .frame(width: 20, height: 18)
            
            Text(title)
                .padding(.leading, 10)
                .lineLimit(1)
            
            Spacer()
            
            if isShowArrow {
                Image("search_arrowright_icon")
            }
        }
        .foregroundColor(.secondary)
        .padding()
    }
}

struct SearchList: View {
    let abc = [1, 2]
    var body: some View {
        ScrollView {
            
            VStack(spacing: 0) {
                SearchHeader(title: "Brand")
                    .background(Color(hex: "F2F2F2"))


                ForEach(abc, id: \.self) { a in
                    SearchListCell(title: "\(a)", icon: "search_shop_icon")
                        .overlay(alignment: .bottom) {
                            if a != abc.last {
                                SeperateLineView(color: .black)
                            }
                        }
                }

                SearchHeader(title: "Keyword Suggestions")
                    .background(Color(hex: "F2F2F2"))

                ForEach(abc, id: \.self) { a in
                    SearchListCell(title: "\(a)", icon: "search_shop_icon")                        .overlay(alignment: .bottom) {
                            if a != abc.last {
                                SeperateLineView(color: .black)
                            }
                        }
                }

                SearchHeader(title: "Keyword Under Categories")
                    .background(Color(hex: "F2F2F2"))

                ForEach(abc, id: \.self) { a in
                    SearchListCell(title: "\(a)", icon: "search_shop_icon")                        .overlay(alignment: .bottom) {
                            if a != abc.last {
                                SeperateLineView(color: .black)
                            }
                        }
                }
                SeperateLineView(color: Color(hex: "F2F2F2"), height: 20)
                SearchListCell(title: "Show all result for beef", icon: "", isShowArrow: false)
                
            }
        }
    }
}


#Preview {
    SearchList()
}












struct SearchView: View {
    
    @StateObject var VM = SearchViewModel.shared
    
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
    
    @StateObject var VM = SearchViewModel.shared
    
    @State private var isShowMore: Bool = false
    
    let keywords: [String]
    
    private let screenWidth = UIScreen.main.bounds.width * 0.95
    
    var body: some View {
        VStack {
            FlexibleView(availableWidth: screenWidth, data: keywords, spacing: 5, alignment: .leading, isShowMore: isShowMore ) {
                title in
                SearchTagCell(title: title)
                    .onTapGesture {
                        VM.searchText = title
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
