//
//  CouponRedeemCell.swift
//  CitySuper-Eshop clone
//
//  Created by LukeLin on 2024/6/3.
//

import SwiftUI

struct CouponRedeemCell: View {
    var body: some View {
        HStack {
            VStack(alignment: .leading, spacing: 35) {
                Text("Redeem Discount")
                    .font(.title3)
                    .fontWeight(.bold)
                
                HStack {
                    Text("Use your discount on E-Shop APP")
                        .font(.caption)
                    Image("arrow_right_green_icon")
                        .resizable()
                        .frame(width: 20, height: 20)
                }
            }
            .foregroundColor(.themeDarkGreen)
            .padding(12)
            
            Spacer()
        }
        .background(.themeLightGreen)
        .cornerRadius(10)
        .padding(.horizontal, 5)
    }
}

#Preview {
    CouponRedeemCell()
}
