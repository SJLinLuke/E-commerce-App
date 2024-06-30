//
//  ProductDetailPriceView.swift
//  CitySuper-Eshop clone
//
//  Created by LukeLin on 2024/5/21.
//

import SwiftUI

struct ProductDetailPriceView: View {
        
    let price             : String
    let comparePrice      : String
    let isCompareWithPrice: Bool
    let isSoldOut         : Bool
    let ShopifyID         : String
    
    var body: some View {
        HStack {
            Text("\(Currency.stringFrom(Decimal(string: price) ?? 0.0))")
                .font(.title3)
                .fontWeight(.bold)
                .foregroundColor(isCompareWithPrice ? .red : .black)
            
            if isCompareWithPrice {
                Text("\(Currency.stringFrom(Decimal(string: comparePrice) ?? 0.0))")
                    .font(.caption)
                    .strikethrough()
                    .foregroundColor(.secondary)
            }
            
            Spacer()
            
            if isSoldOut {
                SoldOutButton(width: 53, height: 30)
            } else {
                CartButton(width: 30, height: 30, shopifyID: ShopifyID)
            }
            
        }
        .padding(.vertical, 5)
    }
}

#Preview {
    ProductDetailPriceView(price: "100", comparePrice: "199", isCompareWithPrice: true, isSoldOut: false, ShopifyID: "")
}
