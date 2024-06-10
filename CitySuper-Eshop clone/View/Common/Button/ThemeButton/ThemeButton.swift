//
//  ThemeButton.swift
//  CitySuper-Eshop clone
//
//  Created by LukeLin on 2024/5/14.
//

import SwiftUI

struct ThemeButton: View {
    
    let title   : String
    var font    : Font.Weight? = .bold
    var width   : CGFloat? = 355
    var height  : CGFloat? = 42
    var iconPath: String?
    var disable : Bool = false
    
    var body: some View {
        Label {
            Text(title)
        } icon: {
            if let iconPath = iconPath {
                Image(iconPath)
                    .renderingMode(.template)
            }
        }
        .font(.headline)
        .fontWeight(font)
        .frame(width: width, height: height)
        .background(disable ? Color(hex: "D2D2D2") : Color.themeDarkGreen)
        .cornerRadius(10)
        .foregroundColor(.white)
    }
}

#Preview {
    ThemeButton(title: "Test Button", iconPath: "search_icon")
}
