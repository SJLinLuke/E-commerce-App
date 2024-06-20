//
//  SearchListCell.swift
//  CitySuper-Eshop clone
//
//  Created by LukeLin on 2024/6/20.
//

import SwiftUI

struct SearchListCell: View {
    
    let text: Text
    
    var iconPath       : String = ""
    var imageSrc       : String?
    var isAccessoryIcon: Bool = true
    
    var body: some View {
        HStack {
            if !iconPath.isEmpty {
                Image(iconPath)
                    .resizable()
                    .frame(width: 20, height: 18)
            }
            
            if let imageSrc = imageSrc {
                RemoteImageView(url: imageSrc, placeholder: .searchList)
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
    SearchListCell(text: Text("TEST"), iconPath: "search_shop_icon")
}
