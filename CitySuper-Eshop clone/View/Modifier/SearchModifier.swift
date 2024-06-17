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
















let data = ["Short", "A bit longer", "Even longer text item", "Short", "Text", "Another longer text item", "More text", "Last item"]

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
                    
                    LazyVGrid(columns: [GridItem(.adaptive(minimum: 50))], spacing: 10) {
                        ForEach(data.indices, id: \.self) { index in
                            Text("\(data[index])")
                                .frame(minWidth: 50, maxWidth: geometry.size.width)
                                .frame(height: 30)
                                .fixedSize(horizontal: true, vertical: false)
                                .background(Color.blue.opacity(0.3))
                                .cornerRadius(5)
                            
                        }
                    }
                    .padding()
                    .frame(width: geometry.size.width)
                }
            })
        }
        .background(Color(hex: "F2F2F2"))
        
    }
}

#Preview {
    abc()
}

