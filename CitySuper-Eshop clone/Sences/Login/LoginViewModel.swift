//
//  LoginViewModel.swift
//  CitySuper-Eshop clone
//
//  Created by LukeLin on 2024/5/14.
//

import SwiftUI
import Combine

@MainActor final class LoginViewModel: ObservableObject {
    
    @Published var userEnv  : UserEnviroment? = nil
    @Published var isLoading: Bool = false
    
    var viewDismissPublisher = PassthroughSubject<Bool, Never>()
    private var shouldDismissView = false {
        didSet {
            viewDismissPublisher.send(shouldDismissView)
            shouldDismissView = false
        }
    }
    
    private var InboxVM      = InboxViewModel.shared
    private var forgetPW_VM  = ForgetPasswordViewModel.shared
    
    var alertManager: AlertManager?
    
    func loginSever(loginData: LoginBody) {
        
        guard !isLoading else { return }
        
        Task {
            do {
                self.isLoading = true
                let userData = try await NetworkManager.shared.login(loginData: loginData)
                
                self.isLoading = false
                self.userEnv?.setupUser(userData)
                if self.userEnv?.isLogin ?? false {
                    shouldDismissView = true
                    if userData.profile.changePassword ?? false {
                        self.userEnv?.currentPassword = loginData.password
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                            self.forgetPW_VM.isChangePassword.toggle()
                        }
                    }
                }
                self.InboxVM.fetchUnreadNumber()
            } catch {
                self.isLoading = false
                if let error = error as? CSAlert {
                    alertManager?.callErrorAlert(error)
                }
            }
            
        }
    }
}

