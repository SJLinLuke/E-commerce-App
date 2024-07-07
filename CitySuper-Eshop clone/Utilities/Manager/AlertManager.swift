//
//  AlertManager.swift
//  CitySuper-Eshop clone
//
//  Created by LukeLin on 2024/7/7.
//

import Foundation
import SwiftUI

@MainActor final class AlertManager: ObservableObject {
    
    static let shared = AlertManager()
    
    @Published var alertItem: AlertItem? {
        didSet {
            isShowAlert.toggle()
        }
    }
    @Published var isShowAlert: Bool = false
    
    func callAlert(title: String, message: String, buttons: [AlertButton]? = nil) {
        self.alertItem = AlertItem(title: title, message: Text(message), buttons: buttons)
    }
    
    func callErrorAlert(_ error: CSAlert) {
        switch error {
        case .inValidURL:
            self.alertItem = AlertContext.inValidURL
        case .inValidData:
            self.alertItem = AlertContext.inValidData
        case .inValidResponse:
            self.alertItem = AlertContext.inValidResponse
        case .customError(let errorMessage):
            self.alertItem = AlertItem(title: "Notice", message: Text(errorMessage))
        }
    }
    
    func callStaticAlert(_ alertItem: AlertItem) {
        self.alertItem = alertItem
    }
    
}
