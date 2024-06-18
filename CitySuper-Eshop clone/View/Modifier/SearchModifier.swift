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
                    //                    absss()
                }
            } else {
                content
            }
        }
    }
}


















struct SearchView: View {
    
    @StateObject var VM = SearchViewModel.shared
    
    var body: some View {
        ScrollView {
            VStack {
                SearchHeader(title: "Recent Searches", buttonTitle: "Clean all") {
                    print("clean all")
                }
                
                SearchTagsView(data: ["123"])
                
                SearchHeader(title: "Hot Keywords")
                
                SearchTagsView(data: VM.hotKeywords)
                
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

#Preview {
    SearchView()
}

struct SearchHeader: View {
    
    let title       : String
    var buttonTitle : String?
    var buttonAction: (() -> Void)?
    
    var body: some View {
        HStack {
            Text(title)
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

struct SearchTagsView: View {
    
    @State private var isShowMore: Bool = false
    
    let data: [String]
    
    private let screenWidth = UIScreen.main.bounds.width
    
    var body: some View {
        VStack {
            FlexibleView(availableWidth: screenWidth, data: data, spacing: 5, alignment: .leading, isShowMore: isShowMore ) {
                FlexibleItem in
                HStack {
                    Text(FlexibleItem)
                    Image("search_arrowright_icon")
                }
                .font(.callout)
                .fontWeight(.medium)
                .frame(height: 30)
                .padding(.horizontal, 10)
                .foregroundColor(.secondary)
                .overlay {
                    RoundedRectangle(cornerRadius: 5)
                        .stroke(.gray ,lineWidth: 1.5)
                }
            }
            
            if !data.isEmpty {
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
                RemoteImageView(url: collection.image_src ?? "", placeholder: .common)
                    .aspectRatio(contentMode: .fit)
                    .frame(height: 170)
            }
        }
        .padding(.bottom)
    }
}
