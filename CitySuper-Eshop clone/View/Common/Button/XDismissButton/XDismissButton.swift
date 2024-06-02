//
//  XDismissButton.swift
//  CitySuper-Eshop clone
//
//  Created by LukeLin on 2024/5/14.
//

import SwiftUI

struct XDismissButton: View {
    
    @Binding var isShowing: Bool
    
    let color : Color
    var width : CGFloat = 20
    var height: CGFloat = 20
    
    var body: some View {
        Button {
            isShowing = false
        } label: {
            Image("close_icon")
                .resizable()
                .renderingMode(.template)
                .frame(width: width, height: height)
                .foregroundColor(color)
        }
    }
}

#Preview {
    XDismissButton(isShowing: .constant(true), color: .black)
}
