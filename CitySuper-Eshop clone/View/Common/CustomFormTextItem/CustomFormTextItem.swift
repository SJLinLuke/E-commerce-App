//
//  OrderHistoryDetailTextItem.swift
//  CitySuper-Eshop clone
//
//  Created by LukeLin on 2024/5/27.
//

import SwiftUI

struct CustomFormTextItem: View {
    
    let leadingText: String
    let trailingText: String
    
    var leadingColor: Color  = .black
    var trailingColor: Color = .black
    
    var leadingFont: Font.Weight  = .regular
    var trailingFont: Font.Weight = .regular
    
    var font: Font                   = .system(size: 16)
    var alignment: VerticalAlignment = .center
    
    var body: some View {
        HStack(alignment: alignment) {
            Text(leadingText)
                .foregroundColor(leadingColor)
                .fontWeight(leadingFont)
            
            Spacer()
            
            Text(trailingText)
                .multilineTextAlignment(.trailing)
                .foregroundColor(trailingColor)
                .fontWeight(trailingFont)
        }
        .font(font)
    }
}

#Preview {
    CustomFormTextItem(leadingText: "Test Leading Text", trailingText: "Test Trailing Text")
}
