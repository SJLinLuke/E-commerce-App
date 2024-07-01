//
//  OrderHistoryDetailSectionHeader.swift
//  CitySuper-Eshop clone
//
//  Created by LukeLin on 2024/5/27.
//

import SwiftUI

struct OrderHistoryDetailSectionHeader: View {
    
    let title      : String
    var buttonTitle: String?
    var action     : (() -> Void)?
    
    var body: some View {
        HStack {
            Text(title)
                .padding(.leading, 5)
                .fontWeight(.bold)
            
            Spacer()
            
            if let action, let buttonTitle {
                Button {
                    action()
                } label: {
                    Text(buttonTitle)
                        .foregroundColor(.themeGreen)
                }
                .padding(.trailing, 5)
            }
        }
        .padding(.vertical)
        .background(Color(hex: "F7F7F7"))
    }
}

#Preview {
    OrderHistoryDetailSectionHeader(title: "Delivery", buttonTitle: "Button", action: {})
}
