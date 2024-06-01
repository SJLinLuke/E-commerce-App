//
//  alertModifier.swift
//  CitySuper-Eshop clone
//
//  Created by LukeLin on 2024/6/1.
//

import Foundation
import SwiftUI

struct AlertModifier: ViewModifier {
    
    let alertItem: AlertItem?
    
    @Binding var isAlertShow: Bool
    
    func body(content: Content) -> some View {
        content
            .alert(alertItem?.title ?? "", isPresented: $isAlertShow, actions: {
                if let buttons = alertItem?.buttons {
                    ForEach(buttons) { button in
                        Button(button.title, role: button.role, action: button.action)
                    }
                }
            }, message: {
                alertItem?.message ?? Text("")
            })

    }
    
}
