//
//  AlertContext.swift
//  CitySuper-Eshop clone
//
//  Created by LukeLin on 2024/5/29.
//

import SwiftUI

struct AlertItem: Identifiable {
    let id = UUID()
    
    let title: String
    let message: Text
    var buttons: [AlertButton] = []
    
    init(title: String, message: Text, buttons: [AlertButton]? = nil) {
        self.title = title
        self.message = message
        self.buttons = buttons ?? []
    }
}

struct AlertButton: Identifiable {
    let id = UUID()
    let title: String
    var role: ButtonRole? = .none
    let action: () -> Void
}

struct AlertContext {
    
    //MARK: - Network Alerts
    
    static let inValidURL      = AlertItem(title: "Server Error",
                                           message: Text("The data received from the server is unvalid. Please contact support."))
    
    static let inValidResponse = AlertItem(title: "Server Error",
                                           message: Text("Invalid response from the server. Please try again later or contact support."))
    
    static let inValidData     = AlertItem(title: "Server Error",
                                           message: Text("There was an issue connecting to the server. If this persists, please contact support."))
    
    //MARK: - Profile Alerts
    
    static let deliveryAddress_delete   = AlertItem(title: "Notice",
                                                    message: Text("Are you sure to delete this saved address?"))
    
    static let deliveryAddress_fillForm = AlertItem(title: "Notice",
                                                    message: Text("Please fill in all required fields"))
}
