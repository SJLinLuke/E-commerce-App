//
//  OrderHistoryDetailTextItem.swift
//  CitySuper-Eshop clone
//
//  Created by LukeLin on 2024/5/27.
//

import SwiftUI

struct OrderHistoryDetailTextItem: View {
    
    var font: Font                   = .system(size: 16)
    var alignment: VerticalAlignment = .center
    let leadingText: String
    let trailingText: String
    
    var body: some View {
        HStack(alignment: alignment) {
            Text(leadingText)
            Spacer()
            Text(trailingText)
                .multilineTextAlignment(.trailing)
        }
        .font(font)
    }
}

#Preview {
    OrderHistoryDetailTextItem(leadingText: "Test Leading Text", trailingText: "Test Trailing Text")
}
