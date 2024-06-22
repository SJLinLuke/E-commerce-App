//
//  ProductCollectionSortBottomSheet.swift
//  CitySuper-Eshop clone
//
//  Created by LukeLin on 2024/6/22.
//

import SwiftUI
import MobileBuySDK

struct ProductCollectionSortBottomSheet: View {
    
    @StateObject private var ProductCollectionVM = ProductCollectionViewModel.shared

    @Binding var isShowSort: Bool
    
    let collectionID: String
    
    let sellingSorts       : [String] = ["Best", "Default Sorting"]
    let priceSorts         : [String] = ["Low to High", "High to Lows"]
    let alphabeticallySorts: [String] = ["A-Z", "Z-A"]
    let dateSorts          : [String] = ["New to Old", "Old to New"]
    
    var body: some View {
        VStack {
            HStack {
                Text("Sort by")
                    .font(.headline)
                    .fontWeight(.bold)
                Spacer()
            }
             
            SortView(currentSortKey: $ProductCollectionVM.currentSortKey, title: "Selling", sortKeyword: sellingSorts, buttonAction: { newSortKey in
                
                switch newSortKey {
                case "Best":
                    ProductCollectionVM.setSortLogic(sortKey: .bestSelling, sortOrder: .ASC, collectionID: collectionID)
                case "Default Sorting":
                    ProductCollectionVM.setSortLogic(sortKey: .manual, sortOrder: .ASC, collectionID: collectionID)
                default:
                    break
                }
                
                isShowSort = false
            })
            
            SortView(currentSortKey: $ProductCollectionVM.currentSortKey, title: "Price", sortKeyword: priceSorts, buttonAction: { newSortKey in
                
                switch newSortKey {
                case "Low to High":
                    ProductCollectionVM.setSortLogic(sortKey: .price, sortOrder: .ASC, collectionID: collectionID)
                case "High to Lows":
                    ProductCollectionVM.setSortLogic(sortKey: .price, sortOrder: .DESC, collectionID: collectionID)
                default:
                    break
                }
                
                isShowSort = false
            })
            
            SortView(currentSortKey: $ProductCollectionVM.currentSortKey, title: "Alphabetically, A-Z", sortKeyword: alphabeticallySorts, buttonAction: { newSortKey in
                
                switch newSortKey {
                case "A-Z":
                    ProductCollectionVM.setSortLogic(sortKey: .title, sortOrder: .ASC, collectionID: collectionID)
                case "Z-A":
                    ProductCollectionVM.setSortLogic(sortKey: .title, sortOrder: .DESC, collectionID: collectionID)
                default:
                    break
                }
                
                isShowSort = false
            })
            
            SortView(currentSortKey: $ProductCollectionVM.currentSortKey, title: "Date", sortKeyword: dateSorts, buttonAction: { newSortKey in
                
                switch newSortKey {
                case "New to Old":
                    ProductCollectionVM.setSortLogic(sortKey: .created, sortOrder: .ASC, collectionID: collectionID)
                case "Old to New":
                    ProductCollectionVM.setSortLogic(sortKey: .created, sortOrder: .DESC, collectionID: collectionID)
                default:
                    break
                }
                
                isShowSort = false
            })
            
            SeperateLineView(color: .gray, height: 1)
            Spacer()
        }
        .padding(EdgeInsets(top: 40, leading: 10, bottom: 0, trailing: 10))
        .presentationDetents([.medium, .medium, .height(UIScreen.main.bounds.height / 2)])
        .presentationBackgroundInteraction(.disabled)
        .presentationCornerRadius(20)
    }
}

#Preview {
    ProductCollectionSortBottomSheet(isShowSort: .constant(true), collectionID: "")
}

struct SortView: View {
    
    @Binding var currentSortKey: String
    
    let title       :String
    let sortKeyword : [String]
    let buttonAction: (String) -> Void
    
    var body: some View {
        VStack {
            
            SeperateLineView(color: .gray, height: 1)
            
            HStack {
                Text(title)
                    .font(.caption)
                    .fontWeight(.medium)
                Spacer()
            }
            .padding(EdgeInsets(top: 2, leading: 0, bottom: 10, trailing: 0))
            
            GeometryReader(content: { geometry in
                LazyVGrid(columns: [GridItem(.adaptive(minimum: geometry.size.width * 0.48, maximum: geometry.size.width * 0.48))], spacing: 25, content: {
                    ForEach(sortKeyword, id: \.self) { sortkey in
                        Button {
                            buttonAction(sortkey)
                            currentSortKey = sortkey
                        } label: {
                            let isSelected: Bool = currentSortKey == sortkey
                            
                            Text(sortkey)
                                .frame(width: geometry.size.width * 0.48, height: 25)
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
        }
    }
}
