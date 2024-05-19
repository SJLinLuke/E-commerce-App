//
//  OrderHistoryCell.swift
//  CitySuper-Eshop clone
//
//  Created by LukeLin on 2024/5/19.
//

import SwiftUI

struct OrderHistoryCell: View {
    
    let orderHistory: OrderViewModel
    let orderInfo   : OrderData
    
    var body: some View {
        ZStack{
            VStack(alignment: .leading) {
                HStack {
                    Text("Order# \(String(orderHistory.number))")
                        .fontWeight(.bold)
                    Spacer()
                    Text("Processing")
                        .fontWeight(.bold)
                        .foregroundColor(.themeGreen2)
                }
                Text("2024/05/16 16:44:56")
                    .font(.caption)
                    .foregroundColor(.secondary)
                
                Progress(height: 7, figureTarget: 180, color: .themeGreen2)
                
                Spacer()
                    .frame(height: 45)
                Text("Amount: HK$\(orderHistory.totalPrice.formattedPrice)")
            }
            .padding(8)
            .background(.white)
            .cornerRadius(10)
            .shadow(color: .secondary, radius: 3, x: 1, y: 1)
        }
        .padding(.horizontal, -13)
        .padding(.bottom, 9)
        .listRowSeparator(.hidden, edges: .all)
    }
}

//#Preview {
//    OrderHistoryCell()
//}
