//
//  SearchTagsView.swift
//  CitySuper-Eshop clone
//
//  Created by LukeLin on 2024/6/20.
//

import SwiftUI

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

#Preview {
    SearchTagsView(keywords: ["TEST"])
}
