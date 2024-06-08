//
//  QuantitySelectorView.swift
//  CitySuper-Eshop clone
//
//  Created by LukeLin on 2024/6/9.
//

import SwiftUI

struct QuantitySelectorView: View {
    
    @State private var isAlertShow: Bool = false
    @State private var alertItem  : AlertItem? {
        didSet {
            self.isAlertShow.toggle()
        }
    }
    
    @Binding var quantity: Int
    
    let inventoryQuantity:Int
    
    var body: some View {
        HStack {
            Button {
                tapMinus()
            } label: {
                Image("minus_icon")
            }
            .frame(width: 28, height: 28)
            .background(Color(hex: "D6D6D6"))
            .cornerRadius(3)
            
            TextField("", value: $quantity, formatter: NumberFormatter())
                .multilineTextAlignment(.center)
                .keyboardType(.numberPad)
                .frame(width: 25)
                .font(.subheadline)
            
            Button {
                tapPlus()
            } label: {
                Image("plus_icon")
            }
            .frame(width: 28, height: 28)
            .background(.themeDarkGreen)
            .cornerRadius(3)
        }
        .overlay {
            RoundedRectangle(cornerRadius: 3)
                .stroke(.secondary, lineWidth: 0.3)
        }
        .modifier(AlertModifier(alertItem: alertItem, isAlertShow: $isAlertShow))
    }
    
    func tapMinus() {
        guard quantity > 1 else { return }
        quantity -= 1
    }
    
    func tapPlus() {
        if quantity < inventoryQuantity {
            quantity += 1
        } else {
            self.alertItem = AlertContext.quantityUnavailable
        }
    }
}

#Preview {
    QuantitySelectorView(quantity: .constant(10), inventoryQuantity: 20)
}
