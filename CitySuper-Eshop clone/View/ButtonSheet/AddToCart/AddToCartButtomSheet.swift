//
//  AddToCartButtomSheet.swift
//  CitySuper-Eshop clone
//
//  Created by LukeLin on 2024/6/8.
//

import SwiftUI

struct AddToCartButtomSheet: View {
    
    @StateObject private var VM = AddToCartButtomSheetViewModel.shared
    
    @State private var quantity   : Int = 1
    
    var body: some View {
     
        VStack {
            Text(VM.product?.title ?? "")
                .fontWeight(.bold)
                .multilineTextAlignment(.center)
                .padding(.top, 45)
            
            SeperateLineView()
            
            HStack {
                
                Text(Currency.stringFrom(Decimal(string: VM.product?.price ?? "0") ?? 0.0))
                    .foregroundColor(VM.isCompareWithPrice ? Color(hex: "E85321") : .black)
                    .fontWeight(.bold)
                
                if VM.isCompareWithPrice {
                    Text(Currency.stringFrom(Decimal(string: VM.product?.compare_at_price ?? "0") ?? 0.0))
                        .strikethrough()
                        .foregroundColor(.secondary)
                }
                
                Spacer()
                
                QuantitySelectorView(quantity: $quantity, inventoryQuantity: VM.product?.inventory_quantity ?? 0)
            }
            .padding(.vertical, 1)
            
            SeperateLineView()
            
            HStack {
                ProductDetailBulletPointsView(tags: VM.product?.logistic_tags ?? [])
                Spacer()
            }
            
            Spacer()
            
            Button {
                
            } label: {
                ThemeButton(title: "Add to Cart")
            }
            
        }
        .padding(.horizontal, 10)
        .presentationDetents([.medium, .large, .height(UIScreen.main.bounds.height / 2.1)])
        .presentationBackgroundInteraction(.disabled)
        .presentationCornerRadius(20)
    }    
}

#Preview {
    AddToCartButtomSheet()
}
