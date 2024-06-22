//
//  SearchResultSortButtomSheet.swift
//  CitySuper-Eshop clone
//
//  Created by LukeLin on 2024/6/22.
//

import SwiftUI

struct SearchResultSortButtomSheet: View {
    
    @StateObject var searchResultVM = SearchResultViewModel.shared
    @StateObject var searchVM       = SearchListViewModel.shared

    @Binding var currentSortKey: String
    @Binding var isShowSortButtonSheet: Bool
    
    private let sortKeys = ["Score", "New to Old", "Old to New"]
    
    var body: some View {
        VStack {
            HStack {
                Text("Sort by")
                    .font(.headline)
                    .fontWeight(.bold)
                Spacer()
            }
            
            SeperateLineView(color: .gray, height: 1)
            
            HStack {
                Text("Date")
                    .font(.caption)
                    .fontWeight(.medium)
                Spacer()
            }
            .padding(EdgeInsets(top: 2, leading: 0, bottom: 10, trailing: 0))
            
            GeometryReader(content: { geometry in
                LazyVGrid(columns: [GridItem(.adaptive(minimum: geometry.size.width * 0.31, maximum: geometry.size.width * 0.32))], spacing: 25, content: {
                    ForEach(sortKeys, id: \.self) { sortkey in
                        Button {
                            if sortkey == "Score" {
                                searchResultVM.sortKey = "SCORE"
                                searchResultVM.sortOrder = .DESC
                                currentSortKey = "Score"
                            } else {
                                searchResultVM.sortKey = "TITLE"
                                if sortkey == "New to Old" {
                                    searchResultVM.sortOrder = .DESC
                                    currentSortKey = "New to Old"
                                } else {
                                    searchResultVM.sortOrder = .ASC
                                    currentSortKey = "Old to New"
                                }
                            }
                            searchResultVM.initConfig()
                            searchResultVM.fetchKeywordProducts(keyword: searchVM.searchText)
                            isShowSortButtonSheet = false
                        } label: {
                            let isSelected: Bool = sortkey == currentSortKey
                            
                            Text(sortkey)
                                .frame(width: geometry.size.width * 0.32, height: 25)
                                .font(.caption)
                                .fontWeight(isSelected ? .regular : .medium)
                                .foregroundColor(isSelected ? .themeGreen : .gray)
                                .background(isSelected ? .white : Color(hex: "F2F2F2"))
                                .cornerRadius(5)
                                .overlay {
                                    if isSelected {
                                        RoundedRectangle(cornerRadius: 5)
                                            .stroke(
                                                LinearGradient(
                                                    colors: [
                                                        Color(hex: "20741B"),
                                                        Color(hex: "7DE489")],
                                                    startPoint: .bottomTrailing,
                                                    endPoint: .topLeading))
                                    }
                                }
                        }
                    }
                })
            })
            
            SeperateLineView(color: .gray, height: 1)
            Spacer()
        }
        .padding(EdgeInsets(top: 40, leading: 10, bottom: 0, trailing: 10))
        .presentationDetents([.medium, .medium, .height(UIScreen.main.bounds.height / 5)])
        .presentationBackgroundInteraction(.disabled)
        .presentationCornerRadius(20)
    }
}

#Preview {
    SearchResultSortButtomSheet(currentSortKey: .constant("Score"), isShowSortButtonSheet: .constant(true))
}
