//
//  AlertContext.swift
//  CitySuper-Eshop clone
//
//  Created by LukeLin on 2024/5/29.
//

import SwiftUI

struct AlertItem: Identifiable {
    let id = UUID()
    let title: Text
    let message: Text
    var dismissButton: Alert.Button?
    
    init(title: Text, message: Text, dismissButton: Alert.Button? = .default(Text("Ok"))) {
        self.title = title
        self.message = message
        self.dismissButton = dismissButton
    }
}

struct AlertContext {
    
    //MARK: - Network Alerts
    
    static let inValidURL       = AlertItem(title: Text("Server Error"),
                                            message: Text("The data received from the server is unvalid. Please contact support."))
    
    static let inValidResponse  = AlertItem(title: Text("Server Error"),
                                            message: Text("Invalid response from the server. Please try again later or contact support."))
    
    static let inValidData      = AlertItem(title: Text("Server Error"),
                                            message: Text("There was an issue connecting to the server. If this persists, please contact support."))
    
    //MARK: - Profile Alerts
    
    static let deliveryAddress_delete = AlertItem(title: Text("Notice"), 
                                                  message: Text("Are you sure to delete this saved address?"))
}
