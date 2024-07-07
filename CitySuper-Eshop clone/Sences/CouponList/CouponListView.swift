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
    
    @StateObject private var confirmationVM: CheckoutConfirmationViewModel

    let isRedeemable: Bool
    
    init(confirmationVM: CheckoutConfirmationViewModel? = nil, isRedeemable: Bool) {
        if let confirmationVM {
            self._confirmationVM = StateObject(wrappedValue: confirmationVM)
        } else {
            self._confirmationVM = StateObject(wrappedValue: CheckoutConfirmationViewModel(checkout: nil, checkedDate: nil, selectedStore: nil, address: nil, checkoutMethod: nil))
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
                            CouponListCell(coupon: coupon, isRedeemable: isRedeemable, 
                            tapOnUse: {
                                confirmationVM.applyDiscount(coupon.discount_code)
                            }, 
                            tapOnRemove: {
                                confirmationVM.removeDiscount(coupon.discount_code)
                            }, isUsed: confirmationVM.isDiscountUsed(coupon.discount_code))
                        }
                    }
                }
            }
            .overlay {
                if VM.isLoading {
                    LoadingIndicatiorView()
                }
                if confirmationVM.isLoading {
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
