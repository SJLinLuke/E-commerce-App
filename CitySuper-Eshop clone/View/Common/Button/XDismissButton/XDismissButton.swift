//
//  XDismissButton.swift
//  CitySuper-Eshop clone
//
//  Created by LukeLin on 2024/5/14.
//

import SwiftUI

struct XDismissButton: View {
    
    @Binding var isShowing: Bool
    
    let color: Color
    
    var body: some View {
        HStack {
            Spacer()
            Button {
                isShowing = false
            } label: {
                 Image("close_icon")
                    .resizable()
                    .renderingMode(.template)
                    .frame(width: 20, height: 20)
//                    .colorMultiply(color)
                    .foregroundColor(color)
            }
        }
    }
}

#Preview {
    XDismissButton(isShowing: .constant(true), color: .black)
}
