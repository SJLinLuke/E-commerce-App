//
//  ShoppingNoticeView.swift
//  CitySuper-Eshop clone
//
//  Created by LukeLin on 2024/6/11.
//

import SwiftUI

struct ShoppingCartNoticeView: View {
    
    let noticeMessage: String
    
    var body: some View {
        ZStack {
            Text(noticeMessage)
                .padding(8)
                .font(.system(size: 14))
                .foregroundColor(.white)
        }
        .frame(maxWidth: .infinity)
        .background(Color(hex: "E84D1B"))
        .padding(.top, 1)
    }
}

#Preview {
    ShoppingCartNoticeView(noticeMessage: "TEST")
}
