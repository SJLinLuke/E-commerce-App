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
    
    private var confirmationVM: CheckoutConfirmationViewModel?

    let isRedeemable: Bool
    
    init(confirmationVM: CheckoutConfirmationViewModel? = nil, isRedeemable: Bool) {
        if let confirmationVM {
            self.confirmationVM = confirmationVM
        }
        self.isRedeemable = isRedeemable
    }
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
                        
                        ForEach(VM.coupons.indices, id: \.self) { index in
                            let coupon = VM.coupons[index]
                            CouponListCell(coupon: coupon, isRedeemable: isRedeemable, tapOnUse: {
                                confirmationVM?.applyDiscount(coupon.discount_code)
                            })
                        }
                    }
                }
            }
            .overlay {
                if VM.isLoading {
                    LoadingIndicatiorView()
                }
                if let confirmationVM, confirmationVM.isLoading {
                    LoadingIndicatiorView(backgroundDisable: true)
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
