//
//  OrderHistoryCell.swift
//  CitySuper-Eshop clone
//
//  Created by LukeLin on 2024/5/19.
//

import SwiftUI

struct OrderHistoryCell: View {
    
    @StateObject var VM = OrderHistoryViewModel.shared
    
    let orderHistory: OrderViewModel
    
    var body: some View {
        ZStack{
            VStack(alignment: .leading) {
                HStack {
                    Text("Order# \(String(orderHistory.number))")
                        .fontWeight(.bold)
                        .foregroundColor(.black)
                    Spacer()
                    Text(orderHistory.orderStatus.status)
                        .fontWeight(.bold)
                        .foregroundColor(orderHistory.orderStatus.color)
                }
                
                Spacer()
                    .frame(height: 2)
                
                Text(orderHistory.processedAt)
                    .font(.system(size: 13))
                    .foregroundColor(.secondary)
                
                Progress(height: 7, 
                         figureTarget: orderHistory.orderStatus.progress,
                         color: orderHistory.orderStatus.color,
                         isAnimated: false)
                
                Text(orderHistory.orderMethodInfo.orderMethodWithDate)
                    .font(.system(size: 13))
                    .foregroundColor(.secondary)
                
                Spacer()
                    .frame(height: 30)
                
                Text("Amount: HK\(Currency.stringFrom(orderHistory.totalPrice))")
                    .foregroundColor(.black)
            }
            .padding(8)
            .background(.white)
            .cornerRadius(10)
            .shadow(color: .secondary, radius: 3, x: 1, y: 1)
        }
        .padding(.horizontal, -13)
        .padding(.bottom, 6.5)
        .listRowSeparator(.hidden, edges: .all)
    }
}

//#Preview {
//    OrderHistoryCell()
//}
