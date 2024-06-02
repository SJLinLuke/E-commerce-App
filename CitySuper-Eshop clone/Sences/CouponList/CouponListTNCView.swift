//
//  CouponListTNCView.swift
//  CitySuper-Eshop clone
//
//  Created by LukeLin on 2024/6/2.
//

import SwiftUI

struct CouponListTNCView: View {
    
    @State var htmlFrameHeight: CGFloat = .zero
    
    let TNCContent: String
    
    var body: some View {
        NavigationStack {
            VStack{
                HTMLLoaderView(htmlFrameHeight: $htmlFrameHeight, htmlString: TNCContent, source: Constants.static_html_source)
                    .frame(height: htmlFrameHeight)
                    .padding()
                Spacer()
            }
            .navigationTitle("Terms of use")
            .navigationBarTitleDisplayMode(.inline)
        }
    }
}

#Preview {
    CouponListTNCView(TNCContent: "T&C")
}
