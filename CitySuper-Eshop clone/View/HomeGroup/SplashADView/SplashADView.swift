//
//  SplashADView.swift
//  CitySuper-Eshop clone
//
//  Created by LukeLin on 2024/7/12.
//

import SwiftUI

struct SplashADView: View {
    
    @Binding var isShow: Bool
    
    let splashAD: SplashAd
    
    var body: some View {
        ZStack {
            Color(.black)
                .ignoresSafeArea(.container)
            RemoteImageView(url: splashAD.image_src ?? "", placeholder: .common)
                .frame(maxWidth: .infinity, maxHeight: 500)
        }
        .overlay(alignment: .topTrailing) {
            Circle()
                .frame(width: 30)
                .foregroundColor(.gray)
            XDismissButton(isShow: $isShow, color: .white, width: 15, height: 15)
        }
    }
}

#Preview {
    SplashADView(isShow: .constant(true),
                 splashAD: SplashAd(id: 1, image_src: "", link_type: "", related_id: "", youtube_id: "", external_url: ""))
}
