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
            Text("\(Currency.stringFrom(Decimal(string: VM.product?.price ?? "0") ?? 0.0))")
                .font(.title3)
                .fontWeight(.bold)
                .foregroundColor(VM.isCompareWithPrice ? .red : .black)
            
            if VM.isCompareWithPrice {
                Text("\(Currency.stringFrom(Decimal(string: VM.product?.compare_at_price ?? "0") ?? 0.0))")
                    .font(.caption)
                    .strikethrough()
                    .foregroundColor(.secondary)
            }
            
            Spacer()
            
            if VM.isSoldOut {
                SoldOutButton(width: 53, height: 30)
            } else {
                CartButton(width: 30, height: 30)
            }
            
        }
        .padding(.vertical, 5)
    }
}

#Preview {
    ProductDetailPriceView()
}
