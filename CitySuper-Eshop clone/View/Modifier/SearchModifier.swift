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
                    abc()
                } else {
//                    absss()
                }
            } else {
                content
            }
        }
    }
}
















let data = ["Short", "A bit longer", "Even longer text item", "Short1", "Text", "Another longer text item", "More text", "Last item"]

struct abc: View {
        
    var body: some View {
        ScrollView {
            GeometryReader(content: { geometry in
                VStack {
                    
                    HStack {
                        Text("Recent Searches")
                            .fontWeight(.bold)
                            .foregroundColor(Color(hex: "777777"))
                        
                        Spacer()
                        
                        Button {
                            
                        } label: {
                            Text("Clean all")
                                .font(.callout)
                                .foregroundColor(.secondary)
                        }
                    }
                    .padding()
                    
                    FlexibleView(availableWidth: geometry.size.width, data: data, spacing: 5, alignment: .leading, isShowMore: false ) {
                        item in
                        HStack {
                            Text(item)
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
                    

                    
                }
            })
        }
        .background(Color(hex: "F2F2F2"))
        
    }
}

#Preview {
    abc()
}

