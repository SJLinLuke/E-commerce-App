//
//  ForgetPasswordViewModel.swift
//  CitySuper-Eshop clone
//
//  Created by LukeLin on 2024/7/7.
//

import Foundation
import Combine

@MainActor final class ForgetPasswordViewModel: ObservableObject {
    
    static let shared = ForgetPasswordViewModel()
    
    @Published var isLoading: Bool            = false
    @Published var isShowForgetPassword: Bool = false
    @Published var isShowVerify: Bool         = false
    @Published var isChangePassword: Bool     = false
    @Published var email: String              = ""
    
    @Published var isResendDisabled: Bool     = true
    @Published var countdown: Int             = 120
    @Published private var timer: Timer?
    
    var alertManager: AlertManager?
    
    var viewDismissPublisher = PassthroughSubject<Bool, Never>()
    private var shouldDismissView = false {
        didSet {
            viewDismissPublisher.send(shouldDismissView)
            shouldDismissView = false
        }
    }
    
    func sendOTP(resend: Bool = false) {
        
        guard !isLoading, !email.isEmpty else { return }
        
        self.isLoading = true
        
        Task {
            do {
                let success = try await NetworkManager.shared.sendOTP(email)
                self.isLoading = false
                if success {
                    if resend {
                        var alert = AlertContext.forgetPassword_resendOTP
                        alert.buttons.append(AlertButton(title: "OK", action: {
                            //restart timer
                            self.isResendDisabled = true
                            self.countdown = 120
                            self.startTimer()
                        }))
                        alertManager?.callStaticAlert(alert)
                    } else {
                        shouldDismissView.toggle()
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                            self.isShowVerify.toggle()
                        }
                    }
                }
            } catch {
                alertManager?.callErrorAlert(error as! CSAlert)
                self.isLoading = false
            }
        }
    }
    
    func resetRandomPassword(otp: String) {
        
        guard !isLoading, !otp.isEmpty else { return }
        
        self.isLoading = true

        Task {
            do {
                let success = try await NetworkManager.shared.resetRandomPassword(email: email, otp: otp)
                self.isLoading = false
                if success {
                    shouldDismissView.toggle()
                }
            } catch {
                alertManager?.callErrorAlert(error as! CSAlert)
                self.isLoading = false
            }
        }
    }
    
    func showForgetPassword() {
        shouldDismissView.toggle()
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            self.isShowForgetPassword.toggle()
        }
    }
    
    func startTimer() {
        timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { _ in
            if self.countdown > 0 {
                self.countdown -= 1
            } else {
                self.timer?.invalidate()
                self.isResendDisabled = false
            }
        }
    }
}
