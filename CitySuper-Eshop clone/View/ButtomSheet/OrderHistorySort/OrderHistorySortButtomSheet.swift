//
//  OrderHistorySortButtonSheet.swift
//  CitySuper-Eshop clone
//
//  Created by LukeLin on 2024/6/6.
//

import SwiftUI

struct OrderHistorySortButtomSheet: View {
    
    private let sortKeys = ["Payment Pending", "Processing", "Refunded", "Completed", "ALL"]
    
    @Binding var isShowSortButtonSheet: Bool
    @Binding var currentSortKey       : String
    
    var body: some View {
        VStack {
            HStack {
                Text("Filter by")
                    .font(.headline)
                    .fontWeight(.bold)
                Spacer()
            }
            
            SeperateLineView(color: .gray, height: 1)
            
            HStack {
                Text("Status")
                    .font(.caption)
                    .fontWeight(.medium)
                Spacer()
            }
            .padding(EdgeInsets(top: 2, leading: 0, bottom: 10, trailing: 0))
            
            GeometryReader(content: { geometry in
                LazyVGrid(columns: [GridItem(), GridItem()], spacing: 25, content: {
                    ForEach(sortKeys, id: \.self) { sortkey in
                        Button {
                            currentSortKey = sortkey
                            isShowSortButtonSheet = false
                        } label: {
                            let isSelected: Bool = sortkey == currentSortKey
                            
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
            
            Spacer()
        }
        .padding(EdgeInsets(top: 40, leading: 10, bottom: 0, trailing: 10))
        .presentationDetents([.medium, .medium, .height(UIScreen.main.bounds.height / 3.2)])
        .presentationBackgroundInteraction(.disabled)
        .presentationCornerRadius(20)
    }
}

#Preview {
    OrderHistorySortButtomSheet(isShowSortButtonSheet: .constant(true), currentSortKey: .constant("ALL"))
}
