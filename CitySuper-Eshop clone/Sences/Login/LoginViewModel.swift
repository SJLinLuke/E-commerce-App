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
   
    func loginSever(loginData: LoginBody, complete: @escaping (Bool) -> Void) {
        
        guard !isLoading else { return }
        
        Task {
            do {
                self.isLoading = true
                let userData = try await NetworkManager.shared.login(loginData: loginData)
                
                self.isLoading = false
                self.userEnv?.setupUser(userData)
            } catch {
                self.isLoading = false
                print(error.localizedDescription)
            }
            
            complete(self.userEnv?.isLogin ?? false)
        }
    }
}

