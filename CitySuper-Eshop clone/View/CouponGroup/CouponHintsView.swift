//
//  CouponHintView.swift
//  CitySuper-Eshop clone
//
//  Created by LukeLin on 2024/6/3.
//

import SwiftUI

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
                    
                    XDismissButton(isShow: $isShowTerms, color: .white, width: 15, height: 15)
                }
                .padding(.horizontal, 8)
            }
            .background(.themeDarkGreen)
            .padding(.top, 0.5)
        }
    }
}

#Preview {
    CouponHintsView()
}
