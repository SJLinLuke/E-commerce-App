//
//  MoreListStaticViewModel.swift
//  CitySuper-Eshop clone
//
//  Created by LukeLin on 2024/6/1.
//

import Foundation

@MainActor final class MoreListStaticPageViewModel: ObservableObject {
    
    @Published var isLoading: Bool     = false
    @Published var htmlContent: String = ""
    
    func fetchStaticPage(pageName: String) {
        
        guard !isLoading else { return }
        
        Task {
            do {
                self.isLoading = true
                self.htmlContent = try await NetworkManager.shared.fetchStaticPage(self.convertPageName(pageName)).pageContent
                self.isLoading = false
            } catch {
                self.isLoading = false
                print(error.localizedDescription)
            }
        }
    }
    
    private func convertPageName(_ pageName: String) -> String {
        switch pageName {
        case "Privacy Policy Statement":
            return "PrivacyPolicy"
            
        case "Terms and Conditions":
            return "TermsAndConditions"
            
        case "License and Permit":
            return "LicensePermit"
            
        case "Disclaimer":
            return "Disclaimer"
            
        default :
            return ""
        }
    }
}
