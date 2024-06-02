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
    
    let isRedeemable: Bool
    
    var body: some View {
        NavigationStack {
            VStack {
                CouponHintsView()
                
                ScrollView {
                    LazyVGrid(columns: [GridItem()]) {
                        
                        if isRedeemable {
                            NavigationLink { CouponListRedeemView() } label: {
                                CouponRedeemCell()
                            }
                        }
                        
                        ForEach(VM.coupons, id: \.self) { coupon in
                            CouponListCell(coupon: coupon, isRedeemable: isRedeemable)
                        }
                    }
                }
                
                Spacer()
            }
            .overlay {
                if VM.isLoading {
                    LoadingIndicatiorView()
                }
            }
            .onAppear {
                if VM.coupons.isEmpty {
                    VM.fetchCoupon()
                }
            }
            .navigationTitle("My Coupon")
            .navigationBarTitleDisplayMode(.inline)
        }
    }
}

#Preview {
    CouponListView(isRedeemable: true)
}

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

struct CouponHintsView: View {
    
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
