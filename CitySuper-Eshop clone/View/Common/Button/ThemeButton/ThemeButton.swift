//
//  ThemeButton.swift
//  CitySuper-Eshop clone
//
//  Created by LukeLin on 2024/5/14.
//

import SwiftUI

struct ThemeButton: View {
    
    let title : String
    let width : CGFloat? = 355
    let height: CGFloat? = 42
    
    var body: some View {
        Text(title)
            .font(.headline)
            .fontWeight(.bold)
            .frame(width: width, height: height)
            .background(Color.themeGreen)
            .cornerRadius(10)
            .foregroundColor(.white)
    }
}

#Preview {
    ThemeButton(title: "Test Button")
}
