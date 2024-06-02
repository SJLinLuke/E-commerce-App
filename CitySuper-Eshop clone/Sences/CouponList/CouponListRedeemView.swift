//
//  CouponRedeemView.swift
//  CitySuper-Eshop clone
//
//  Created by LukeLin on 2024/6/2.
//

import SwiftUI

struct CouponListRedeemView: View {
    
    @State var voucherNumber: String = ""
    
    var body: some View {
        NavigationStack {
            VStack {
                Image("voucher_icon")
                    .resizable()
                    .frame(width: 130, height: 130)
                    .padding(.top, 35)
                
                Text("Redeem Voucher")
                    .font(.system(size: 20))
                    .fontWeight(.bold)
                    .padding()
                
                HStack {
                    Text("Enter Voucher Number")
                    Spacer()
                }
                .padding(.leading)
                
                CustomTextField(placeHolder: "Voucher", text: $voucherNumber)
                    .padding(.horizontal)
                
                Button {
                    
                } label: {
                    ThemeButton(title: "Redeem")
                }
                .padding()
                
                Button {
                    
                } label: {
                    Text("Use Camera to scan the barcode")
                        .foregroundColor(.black)
                        .underline()
    
                }
                .padding(.top, 30)
                
                Spacer()
            }
            .navigationTitle("My Coupon")
            .navigationBarTitleDisplayMode(.inline)
        }
    }
}

#Preview {
    CouponListRedeemView()
}
