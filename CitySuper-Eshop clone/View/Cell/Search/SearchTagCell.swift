//
//  SearchTagCell.swift
//  CitySuper-Eshop clone
//
//  Created by LukeLin on 2024/6/20.
//

import SwiftUI

struct SearchTagCell: View {
    
    let title: String
    
    var body: some View {
        HStack {
            Text(title)
            Image("search_arrowright_icon")
                .resizable()
                .frame(width: 6, height: 8)
        }
        .font(.system(size: 14))
        .frame(height: 28)
        .padding(.horizontal, 5)
        .foregroundColor(.secondary)
        .overlay {
            RoundedRectangle(cornerRadius: 4)
                .stroke(.gray ,lineWidth: 1)
        }
    }
}

#Preview {
    SearchTagCell(title: "TEST")
}
