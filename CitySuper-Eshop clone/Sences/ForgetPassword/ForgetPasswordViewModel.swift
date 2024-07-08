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
    
    @Published var isShowForgetPassword: Bool = false
    
    var viewDismissPublisher = PassthroughSubject<Bool, Never>()
    private var shouldDismissView = false {
        didSet {
            viewDismissPublisher.send(shouldDismissView)
        }
    }
    
    func showForgetPassword() {
        shouldDismissView = true
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            self.isShowForgetPassword = true
        }
        
    }
}
