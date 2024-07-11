//
//  ChangePasswordViewModel.swift
//  CitySuper-Eshop clone
//
//  Created by LukeLin on 2024/7/11.
//

import Foundation
import Combine

@MainActor final class ChangePasswordViewModel: ObservableObject {
    
    @Published var isLoading: Bool = false
    
    @Published var newPassword: String        = ""
    @Published var confirmNewPassword: String = ""
    
    var viewDismissPublisher = PassthroughSubject<Bool, Never>()
    private var shouldDismissView = false {
        didSet {
            viewDismissPublisher.send(shouldDismissView)
            shouldDismissView = false
        }
    }
    
    var isPasswordMatch: Bool {
        newPassword == confirmNewPassword
    }
    
    var alertManager: AlertManager?
    
    func updatePassword(password: String, newPassword: String) {
        
        guard !isLoading else { return }
        
        guard !password.isEmpty, !newPassword.isEmpty else {
            let alert = AlertContext.forgetPassword_fillPassword
            alertManager?.callStaticAlert(alert)
            return
        }
        
        guard self.newPassword == self.confirmNewPassword else {
            let alert = AlertContext.forgetPassword_passwordNotMatch
            alertManager?.callStaticAlert(alert)
            return
        }
        
        isLoading = true
        
        Task {
            do {
                let success = try await NetworkManager.shared.updatePassword(password: password, newPassword: newPassword)
                isLoading = false
                if success {
                    var alert = AlertContext.forgetPassword_passwordUpdated
                    alert.buttons.append(AlertButton(title: "OK", action: {
                        self.shouldDismissView.toggle()
                    }))
                    alertManager?.callStaticAlert(alert)
                }
            } catch {
                isLoading = false
                alertManager?.callErrorAlert(error as! CSAlert)
            }
        }
    }
    
    func isPasswordValid(_ password: String) -> Bool {
        guard !password.isEmpty else { return true }
        let specialcharacterRegEx = "^(?=.*[a-z])(?=.*[A-Z])(?=.*[0-9])(?=.*[@$!%*?&+/=_#.^`,';:~×-])[a-zA-Z0-9@$!%*?&+/=_#.^`,';:~×-]{8,16}$"
        let textTest = NSPredicate(format:"SELF MATCHES %@", specialcharacterRegEx)
        guard textTest.evaluate(with: password) else { return false }

        return true
    }
}
