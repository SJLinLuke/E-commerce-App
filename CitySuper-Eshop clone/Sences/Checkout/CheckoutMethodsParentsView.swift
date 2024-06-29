//
//  CheckoutDelivery.swift
//  CitySuper-Eshop clone
//
//  Created by LukeLin on 2024/6/24.
//

import SwiftUI

struct CheckoutMethodsParentsView: View {
    
    @EnvironmentObject private var cartEnv: CartEnvironment
            
    private let screenWidth = UIScreen.main.bounds.width
    
    var body: some View {
        VStack(spacing: 0) {
            HStack(spacing: 0) {
                ForEach(cartEnv.availableMethods, id: \.self) { method in
                    
                    let isSelected: Bool = method == cartEnv.currentMethod
                    
                    Text(method.rawValue)
                        .frame(width: screenWidth / CGFloat(cartEnv.availableMethods.count), 
                               height: 60)
                        .fontWeight(isSelected ? .semibold : .regular)
                        .overlay(alignment: .bottom) {
                            if (isSelected) {
                                Spacer()
                                    .frame(height: 2)
                                    .background(Color(hex: "#46742D"))
                            }
                        }
                        .onTapGesture {
                            withAnimation {
                                cartEnv.currentMethod = method
                            }
                        }
                }
            }
            .background(Color(hex: "F2F2F2"))
            .padding()
            
            
            TabView(selection: $cartEnv.currentMethod) {
                ForEach(cartEnv.availableMethods, id: \.self) { method in
                    switch cartEnv.currentMethod {
                    case .delivery:
                        DeliveryView()
                    case .pickup:
                        pickup()
                    }
                }
            }
            .tabViewStyle(.page(indexDisplayMode: .never))
            .padding(EdgeInsets(top: -15, leading: 0, bottom: -10, trailing: 0))
            
            Spacer()
        }
        .modifier(NavigationModifier(isHideCollectionsList: true, isHideShoppingCart: true))
    }
}

struct pickup: View {
    var body: some View {
        Text("pickup")
    }
}

#Preview {
    CheckoutMethodsParentsView()
        .environmentObject(CartEnvironment())
}
