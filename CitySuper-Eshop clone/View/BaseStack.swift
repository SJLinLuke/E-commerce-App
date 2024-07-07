//
//  BaseStack.swift
//  CitySuper-Eshop clone
//
//  Created by LukeLin on 2024/7/7.
//

import Foundation
import SwiftUI

struct BaseStack<Content: View>: View {
    
    @StateObject private var alertManager = AlertManager.shared
    
    var content: () -> Content
    init(@ViewBuilder content: @escaping () -> Content) {
        self.content = content
    }
    
    var body: some View {
        VStack(content: content)
            .alert(alertManager.alertItem?.title ?? "", isPresented: $alertManager.isShowAlert, actions: {
                if let buttons = alertManager.alertItem?.buttons {
                    ForEach(buttons) { button in
                        Button(button.title, role: button.role, action: button.action)
                    }
                }
            }, message: {
                alertManager.alertItem?.message ?? Text("")
            })
    }
}
