//
//  CouponListView.swift
//  CitySuper-Eshop clone
//
//  Created by LukeLin on 2024/6/2.
//

import SwiftUI

struct CouponListView: View {
    
    @StateObject var VM = CouponListViewModel.shared
    
    @State private var isVoucher: Bool = false
    
    var body: some View {
        NavigationStack {
            VStack {
                CouponTermsView()
                ScrollView {
                    GeometryReader(content: { geometry in
                        LazyVGrid(columns: [GridItem()]) {
                            ZStack {
                                Image("bg_coupon")
                                    .renderingMode(.template)
                                    .foregroundColor(.themeLightGreen)
                                    .overlay(alignment: .topLeading) {
                                        Text("New")
                                            .frame(width: 48, height: 19)
                                            .foregroundColor(.white)
                                            .font(.system(size: 12))
                                            .background(Color(hex: "E85321"))
                                            .cornerRadius(13)
                                            .padding(.leading, 10)
                                    }
                                
                                HStack {
                                    VStack(alignment: .leading) {
                                        Text("testing20210309 (no expired date)")
                                            .font(.title3)
                                            .fontWeight(.bold)
                                        Text("Desc")
                                            .font(.caption)
                                        
                                        Spacer()
                                        
                                        Text("Valid Until: 31/12/2024")
                                            .font(.caption)
                                        
                                        if isVoucher {
                                            Text("Number: **********1234")
                                                .font(.caption)
                                        } else {
                                            Button {
                                                
                                            } label: {
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
                                    .frame(maxWidth: geometry.size.width * 0.25)
                                    .padding(.vertical)
                                    
                                    
                                    Spacer()
                                }
                            }
                        }
                    })
                }
                Spacer()
            }
            .navigationTitle("My Coupon")
            .navigationBarTitleDisplayMode(.inline)
        }
    }
}

#Preview {
    CouponListView()
}

struct CouponTermsView: View {
    
    @State private var isShowTerms: Bool = true

    var body: some View {
        if isShowTerms {
            ZStack {
                HStack {
                    Text("These coupons are only applicable to E-Shop online shopping. Terms & conditions apply.")
                        .font(.caption)
                        .foregroundColor(.white)
                        .padding(.vertical, 20)
                    
                    Spacer()
                    
                    XDismissButton(isShowing: $isShowTerms, color: .white, width: 15, height: 15)
                }
                .padding(.horizontal, 8)
            }
            .background(.themeDarkGreen)
            .padding(.top, 0.5)

            
        }
    }
}
