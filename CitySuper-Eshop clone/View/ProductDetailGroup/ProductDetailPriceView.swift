//
//  ProductDetailPriceView.swift
//  CitySuper-Eshop clone
//
//  Created by LukeLin on 2024/5/21.
//

import SwiftUI

struct ProductDetailPriceView: View {
    
    @StateObject var VM = ProductDetailViewModel.shared
    
    var body: some View {
        HStack {
            Text("$100,000.00")
                .font(.title3)
                .fontWeight(.bold)
                .foregroundColor(VM.isCompareWithPrice ? .red : .black)
            
            if VM.isCompareWithPrice {
                Text("$999")
                    .font(.caption)
                    .strikethrough()
                    .foregroundColor(.secondary)
            }
            
            Spacer()
            
            SoldOutButton(width: 53, height: 30)
        }
        .padding(.vertical, 5)
    }
}

#Preview {
    ProductDetailPriceView()
}
