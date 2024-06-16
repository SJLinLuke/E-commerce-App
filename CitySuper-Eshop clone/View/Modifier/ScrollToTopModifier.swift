//
//  ScrollToTopModifier.swift
//  CitySuper-Eshop clone
//
//  Created by LukeLin on 2024/6/16.
//

import Foundation
import SwiftUI

struct ScrollToTopModifier: ViewModifier {
    
    @Binding var isShowBackToTop: Bool
    
    func body(content: Content) -> some View {
        content
            .background(GeometryReader { geometry in
                Color.clear
                    .preference(key: ScrollOffsetPreferenceKey.self, value: geometry.frame(in: .named("scroll")).origin)
            })
            .onPreferenceChange(ScrollOffsetPreferenceKey.self) { value in
                DispatchQueue.main.async {
                    withAnimation {
                        if value.y < 120 {
                            self.isShowBackToTop = true
                        } else {
                            self.isShowBackToTop = false
                        }
                    }
                }
            }
        
    }
}
