//
//  PopupViewModifier.swift
//  CitySuper-Eshop clone
//
//  Created by LukeLin on 2024/6/14.
//

import SwiftUI

struct PopupViewModifier: ViewModifier {
    
    @State private var isShow: Bool = false
    @State private var type  : PopViewType = .cart_add
    
    func body(content: Content) -> some View {
        content
            .onAppear {
                addObservers()
            }
            .overlay {
                if isShow {
                    PopupAnimateView(isShow: $isShow, type: type)
                }
            }
    }
    
    private func addObservers() {
        NotificationCenter.default.addObserver(forName: Notification.Name.addToCart_Popup, object: nil, queue: .main) { _ in
            DispatchQueue.main.async {
                type = .cart_add
                isShow = true
            }
        }
    }
}

