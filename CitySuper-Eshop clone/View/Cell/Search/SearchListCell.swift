//
//  SearchListCell.swift
//  CitySuper-Eshop clone
//
//  Created by LukeLin on 2024/6/20.
//

import SwiftUI

struct SearchListCell: View {
    
    let text : Text
    let icon : String
    
    var isAccessoryIcon: Bool = true
    
    var body: some View {
        HStack {
            if !icon.isEmpty {
                Image(icon)
                    .resizable()
                    .frame(width: 20, height: 18)
            }
            
            text
                .padding(.leading, 10)
                .lineLimit(1)
            
            Spacer()
            
            if isAccessoryIcon {
                Image("search_arrowright_icon")
            }
        }
        .foregroundColor(.secondary)
        .padding()
    }
}

#Preview {
    SearchListCell(text: Text("TEST"), icon: "search_shop_icon")
}
