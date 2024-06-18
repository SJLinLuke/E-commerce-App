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
    
    var body: some View {
        ScrollView {
            VStack {
                SearchHeader(title: "Recent Searches", buttonTitle: "Clean all") {
                    print("clean all")
                }
                
                SearchTagsView()
                
                SearchHeader(title: "Hot Keywords")
                
                SearchTagsView()
                
                SearchHeader(title: "Recommendation Collections")
                
                SearchRecommendationView()
                
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
    
    let data = ["Short", "A bit longer", "Even longer text item", "Short1", "Text", "Another longer text item", "More text", "Last item"]
    
    @State private var isShowMore: Bool = false
    
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

struct SearchRecommendationView: View {
    
    private let width = UIScreen.main.bounds.width / 2.25
    
    var body: some View {
        LazyVGrid(columns: [GridItem(.adaptive(minimum: width, maximum: width))]) {
            Rectangle()
                .frame(height: 170)
            Rectangle()
                .frame(height: 170)
            Rectangle()
                .frame(height: 170)
            Rectangle()
                .frame(height: 170)
            Rectangle()
                .frame(height: 170)
            Rectangle()
                .frame(height: 170)
        }
        .padding(.bottom)
    }
}
