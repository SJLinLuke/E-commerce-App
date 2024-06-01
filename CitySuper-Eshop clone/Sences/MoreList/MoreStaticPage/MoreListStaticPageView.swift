//
//  MoreListStaticPageView.swift
//  CitySuper-Eshop clone
//
//  Created by LukeLin on 2024/6/1.
//

import SwiftUI

struct MoreListStaticPageView: View {
    
    @StateObject var VM = MoreListStaticPageViewModel()
    
    @State var htmlFrameHeight: CGFloat = .zero
    
    let pageName: String
    
    var body: some View {
        NavigationStack {
            ScrollView {
                HTMLLoaderView(htmlFrameHeight: $htmlFrameHeight,
                               htmlString: VM.htmlContent,
                               source: Constants.static_html_source)
                .frame(height: htmlFrameHeight)
                .padding()
                
            }
            .navigationTitle(pageName)
            .navigationBarTitleDisplayMode(.inline)
            .onAppear {
                VM.fetchStaticPage(pageName: pageName)
            }
        }
        .overlay {
            if VM.isLoading {
                LoadingIndicatiorView()
            }
        }
    }
}

#Preview {
    MoreListStaticPageView(pageName: "Terms and Conditions")
}
