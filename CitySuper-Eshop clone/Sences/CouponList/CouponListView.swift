//
//  CouponListView.swift
//  CitySuper-Eshop clone
//
//  Created by LukeLin on 2024/6/2.
//

import SwiftUI

struct CouponListView: View {
    
    @StateObject var VM = CouponListViewModel.shared
//    @StateObject var confirmationVM: CheckoutConfirmationViewModel
    
    @State private var isVoucher: Bool = false
    
    let isRedeemable: Bool
    
//    init(confirmationVM: CheckoutConfirmationViewModel? = nil, isRedeemable: Bool) {
//        if let confirmationVM {
//            self._confirmationVM = StateObject(wrappedValue: confirmationVM)
//        }
//        self.isRedeemable = isRedeemable
//    }
//    
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

//#Preview {
//    CouponListView(isRedeemable: true)
//}
