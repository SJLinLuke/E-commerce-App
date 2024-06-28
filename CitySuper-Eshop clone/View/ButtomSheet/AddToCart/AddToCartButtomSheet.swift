//
//  AddToCartButtomSheet.swift
//  CitySuper-Eshop clone
//
//  Created by LukeLin on 2024/6/8.
//

import SwiftUI

struct AddToCartButtomSheet: View {
    
    @EnvironmentObject private var cartEnv: CartEnvironment

    @StateObject private var VM = AddToCartButtomSheetViewModel.shared
    
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
                
                QuantitySelectorView()
            }
            .padding(.vertical, 1)
            
            SeperateLineView()
            
            HStack {
                BulletPointsView(tags: VM.product?.logistic_tags ?? [])
                Spacer()
            }
            
            Spacer()
            
            Button {
                VM.tapAddToCart()
            } label: {
                ThemeButton(title: "Add to Cart")
            }
            
        }
        .padding(.horizontal, 10)
        .presentationDetents([.medium, .medium, .height(UIScreen.main.bounds.height / 2.1)])
        .presentationBackgroundInteraction(.disabled)
        .presentationCornerRadius(20)
        .onAppear {
            VM.cartEnv = cartEnv
        }
        .onDisappear {
            VM.quantity = 1
        }
        .modifier(AlertModifier(alertItem: VM.alertItem, isAlertShow: $VM.isAlertShow))
    }
}

#Preview {
    AddToCartButtomSheet()
}
