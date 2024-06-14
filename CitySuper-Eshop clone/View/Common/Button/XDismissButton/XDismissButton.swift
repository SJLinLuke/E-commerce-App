//
//  XDismissButton.swift
//  CitySuper-Eshop clone
//
//  Created by LukeLin on 2024/5/14.
//

import SwiftUI

struct XDismissButton: View {
    
    @Binding var isShow: Bool
    
    let color : Color
    var width : CGFloat = 20
    var height: CGFloat = 20
    var onComplete: (() -> Void)?
    
    var body: some View {
        Button {
            isShow = false
            if let onComplete = onComplete {
                onComplete()
            }
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
    XDismissButton(isShow: .constant(true), color: .black)
}
