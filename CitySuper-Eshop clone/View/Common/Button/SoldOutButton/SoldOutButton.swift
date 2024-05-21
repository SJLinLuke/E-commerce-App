//
//  SoldOutButton.swift
//  CitySuper-Eshop clone
//
//  Created by LukeLin on 2024/5/21.
//

import SwiftUI

struct SoldOutButton: View {
    
    var width : CGFloat
    var height: CGFloat
    
    init(width: CGFloat, height: CGFloat) {
        self.width = width
        self.height = height
    }
    
    
    var body: some View {
        Button {
            
        } label: {
            Text("Sold out")
                .font(.caption)
                .foregroundColor(.white)
                .frame(width: width, height: height)
                .background(Color(hex: "#AAAAAA"))
                .cornerRadius(5)
        }
    }
}

#Preview {
    SoldOutButton(width: 53, height: 25)
}
