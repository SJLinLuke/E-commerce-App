//
//  BackToTopButton.swift
//  CitySuper-Eshop clone
//
//  Created by LukeLin on 2024/5/14.
//

import SwiftUI

struct BackToTopButton: View {
    
    let isShow: Bool
    
    var body: some View {
        if (isShow) {
            Image("backtotop_icon")
                .resizable()
                .frame(width: 60, height: 60)
                .shadow(radius: 1)
                .padding(.trailing, 15)
                .padding(.bottom, 15)
        }
    }
}

#Preview {
    BackToTopButton(isShow: true)
}
