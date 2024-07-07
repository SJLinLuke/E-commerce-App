//
//  LoginViewModel.swift
//  CitySuper-Eshop clone
//
//  Created by LukeLin on 2024/5/14.
//

import SwiftUI

@MainActor final class LoginViewModel: ObservableObject {
    
    @Published var userEnv  : UserEnviroment? = nil
    @Published var isLoading: Bool = false
   
    private var InboxVM      = InboxViewModel.shared
    private var alertManager = AlertManager.shared
    
    func loginSever(loginData: LoginBody, complete: @escaping (Bool) -> Void) {
        
        guard !isLoading else { return }
        
        Task {
            do {
                self.isLoading = true
                let userData = try await NetworkManager.shared.login(loginData: loginData)
                
                self.isLoading = false
                self.userEnv?.setupUser(userData)
                self.InboxVM.fetchUnreadNumber()
            } catch {
                self.isLoading = false
                alertManager.callErrorAlert(error as! CSAlert)
            }
            
            complete(self.userEnv?.isLogin ?? false)
        }
    }
}

