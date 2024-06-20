//
//  RemoteImageView.swift
//  CitySuper-Eshop clone
//
//  Created by LukeLin on 2024/5/12.
//

import SwiftUI

enum PlaceholderType {
    case common
    case inbox
    case searchList
}

struct RemoteImageView: View {
    
    let url: String
    let placeholder: PlaceholderType?
    
    var body: some View {
        AsyncImage(url: URL(string: url)) { image in
            image
                .resizable()
        } placeholder: {
            switch placeholder {
            case .common:
                Image("common_placeholder")
                    .resizable()
            case .inbox:
                Image("inbox_placeholder")
                    .resizable()
            case .searchList:
                Image("search_fruit_placeholder")
                    .resizable()
            case nil:
                Image("common_placeholder")
                    .resizable()
            }
        }
    }
}

#Preview {
    RemoteImageView(url: "", placeholder: .common)
}
