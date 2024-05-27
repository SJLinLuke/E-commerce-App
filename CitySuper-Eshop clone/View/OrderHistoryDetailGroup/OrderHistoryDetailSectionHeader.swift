//
//  OrderHistoryDetailSectionHeader.swift
//  CitySuper-Eshop clone
//
//  Created by LukeLin on 2024/5/27.
//

import SwiftUI

struct OrderHistoryDetailSectionHeader: View {
    
    let title: String
    
    var body: some View {
        HStack {
            Text(title)
                .fontWeight(.bold)
                .padding(.vertical)
                .padding(.leading, 5)
            
            Spacer()
        }
        .background(Color(hex: "F7F7F7"))
    }
}

#Preview {
    OrderHistoryDetailSectionHeader(title: "Delivery")
}
