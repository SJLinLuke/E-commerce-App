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
    let title : String
    var role  : ButtonRole? = .none
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
                                                    message: Text("Please fill in all required fields."))
    
    static let forgetPassword_resendOTP = AlertItem(title: "Notice",
                                                    message: Text("A new OTP has been sent to your registered email address."))
    
    static let forgetPassword_fillPassword = AlertItem(title: "Notice",
                                                    message: Text("Password cannot be empty."))
    
    static let forgetPassword_passwordNotMatch = AlertItem(title: "Notice",
                                                    message: Text("Please confirm your password."))
    
    static let forgetPassword_passwordUpdated = AlertItem(title: "Notice",
                                                    message: Text("Password reset successfully."))
    
    //MARK: - inventory Alerts
    
    static let outOfStock          = AlertItem(title: "Notice",
                                               message: Text("This item is out of stock."))
    
    static let quantityUnavailable = AlertItem(title: "Notice",
                                               message: Text("Your desired quantity is unavailable."))
    
    static let clearCart           = AlertItem(title: "Notice",
                                               message: Text("Are you sure to clear all items in cart?"))
}
