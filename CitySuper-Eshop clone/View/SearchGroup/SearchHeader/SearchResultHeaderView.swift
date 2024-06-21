//
//  SearchResultHeaderView.swift
//  CitySuper-Eshop clone
//
//  Created by LukeLin on 2024/6/21.
//

import SwiftUI

enum SearchResultType {
    case products
    case collections
}

struct SearchResultHeaderView: View {
        
    @Binding var currentSelected: SearchResultType
 
    private let edgeInsets = EdgeInsets(top: 7, leading: 15, bottom: 7, trailing: 15)
    
    var body: some View {
        HStack {
            Button {
                currentSelected = .products
            } label: {
                Text("Products")
                    .padding(edgeInsets)
                    .overlay {
                        RoundedRectangle(cornerRadius: 5)
                            .stroke(.secondary ,lineWidth: 1)
                    }
                    .foregroundColor(currentSelected == .products ? .white : Color(hex: "777777") )
                    .background(currentSelected == .products ? Color(hex: "777777") : .white)
                    .cornerRadius(5)
                    .padding(.leading)
            }
            
            Button {
                currentSelected = .collections
            } label: {
                Text("Collections")
                    .padding(edgeInsets)
                    .overlay {
                        RoundedRectangle(cornerRadius: 5)
                            .stroke(lineWidth: 1)
                    }
                    .foregroundColor(currentSelected == .collections ? .white : Color(hex: "777777") )
                    .background(currentSelected == .collections ? Color(hex: "777777") : .white)
                    .cornerRadius(5)
            }
            Spacer()
        }
        .padding(.vertical)
        .background(Color(hex: "F2F2F2"))
        .padding(.top, 1)
    }
}

#Preview {
    SearchResultHeaderView(currentSelected: .constant(.products))
        .environmentObject(CartEnvironment())
}
