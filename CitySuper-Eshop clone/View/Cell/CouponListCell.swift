//
//  CouponListCell.swift
//  CitySuper-Eshop clone
//
//  Created by LukeLin on 2024/6/2.
//

import SwiftUI

struct CouponListCell: View {
    
    let coupon      : CouponData
    let isRedeemable: Bool
    
    var body: some View {
        ZStack {
            Image("bg_coupon")
                .renderingMode(.template)
                .foregroundColor(.themeLightGreen)
                .overlay(alignment: .topLeading) {
                    if false {
                        Text("New")
                            .frame(width: 48, height: 19)
                            .foregroundColor(.white)
                            .font(.system(size: 12))
                            .background(Color(hex: "E85321"))
                            .cornerRadius(13)
                            .padding(.leading, 10)
                    }
                }
            
            GeometryReader{ geometry in
                HStack {
                    VStack(alignment: .leading) {
                        Text(coupon.discount_code)
                            .font(.title3)
                            .fontWeight(.bold)
                        
                        Text(coupon.description ?? "")
                            .font(.caption)
                        
                        Spacer()
                        
                        if let vaild_to = coupon.valid_to {
                            Text("Valid Until: \(vaild_to.convertDataFormat(fromFormat: "yyyy-MM-dd HH:mm:ss", toFormat: "dd-MM-yyyy"))")
                                .font(.caption)
                        }
                        
                        if false {
                            Text("Number: **********1234")
                                .font(.caption)
                        } else {
                            NavigationLink { CouponListTNCView(TNCContent: coupon.tnc ?? "") } label: {
                                Text("Terms of use")
                                    .font(.caption)
                                    .underline()
                            }
                        }
                    }
                    .frame(maxWidth: geometry.size.width * 0.7, alignment: .leading)
                    .padding(.top, 5)
                    .padding()
                    .foregroundColor(.themeDarkGreen)
                    
                    Spacer()
                    
                    VStack {
                        Text("HK$100")
                            .fontWeight(.bold)
                            .foregroundColor(.themeDarkGreen)
                        
                        Spacer()
                        
                        if isRedeemable {
                            Button {
                                
                            } label: {
                                Text("Use")
                                    .font(.system(size: 12))
                                    .foregroundColor(.white)
                                    .frame(width: 60, height: 27)
                                    .background(.themeDarkGreen)
                                    .cornerRadius(13)
                            }
                        }
                    }
                    .frame(maxWidth: geometry.size.width * 0.25)
                    .padding(.vertical)
                    
                    Spacer()
                }
            }
        }
    }
}

#Preview {
    CouponListCell(coupon: CouponData(discount_id: "", discount_code: "Test", description: "Test", valid_to: nil, type: nil, price: nil, tnc: nil), isRedeemable: true)
        .frame(height: 100)
}
