//
//  StripeManager.swift
//  CitySuper-Eshop clone
//
//  Created by LukeLin on 2024/7/14.
//

import Stripe
import SwiftUICore
import SwiftUI

@MainActor final class StripeManager: NSObject, STPCustomerEphemeralKeyProvider {
    
    static let shared = StripeManager()
    
    var userEnv: UserEnviroment? = nil
    
    var config: STPPaymentConfiguration{
        let config = STPPaymentConfiguration()
            config.requiredBillingAddressFields = .none
        return config
    }
    
    var theme: STPTheme {
        let theme = STPTheme.init()
        
        theme.primaryBackgroundColor   = UIColor(red:230.0/255.0, green:235.0/255.0, blue:241.0/255.0, alpha:255.0/255.0)
        theme.secondaryBackgroundColor = .white
        theme.primaryForegroundColor   = UIColor(red:55.0/255.0, green:53.0/255.0, blue:100.0/255.0, alpha:255.0/255.0)
        theme.secondaryForegroundColor = UIColor(red:130.0/255.0, green:147.0/255.0, blue:168.0/255.0, alpha:255.0/255.0)
        theme.accentColor              = UIColor(red:53.0/255.0, green:117.0/255.0, blue:32.0/255.0, alpha:255.0/255.0)
        theme.errorColor               = UIColor(red:240.0/255.0, green:2.0/255.0, blue:36.0/255.0, alpha:255.0/255.0)
        
        return theme
        
    }
    
    nonisolated func createCustomerKey(withAPIVersion apiVersion: String, completion: @escaping Stripe.STPJSONResponseCompletionBlock) {
        Task {
            do {
                let data = try await NetworkManager.shared.createStripeCustomerKey()
                completion(data, nil)
            } catch {
                print(error)
                completion(nil, error)
            }
        }
    }
    
    func createPaymentIntent(completion: @escaping (String?) -> Void){
        
        guard let userEnv = userEnv else { return }
        
        Task {
            do {
                let client_secret_key = try await NetworkManager.shared.createStripePaymentIntent(userEnv.currentOrderID)
                completion(client_secret_key)
            } catch {
                print(error)
            }
        }
    }
}

class PaymentContextDelegate: NSObject, @preconcurrency STPPaymentContextDelegate, ObservableObject {

    static let shared = PaymentContextDelegate()
    
    var alertManager: AlertManager?
    var cartEnv: CartEnvironment? = nil
        
    @Published var isLoading     : Bool = false
    @Published var isShowComolete: Bool = false
    
    @Published var paymentSheetFlowController: PaymentSheet.FlowController?
    @Published var selectedPaymentOption     : STPPaymentOption?
    @Published var paymentMethod             : NSMutableAttributedString = NSMutableAttributedString(string:"")
    
    func paymentContext(_ paymentContext: Stripe.STPPaymentContext, didFailToLoadWithError error: any Error) {
        print(paymentContext)
    }
    
    func paymentContextDidChange(_ paymentContext: Stripe.STPPaymentContext) {
        if let selectedPaymentOption = paymentContext.selectedPaymentOption{
            
            self.selectedPaymentOption = selectedPaymentOption
            
            if let selectedPaymentOption = self.selectedPaymentOption{
                
                let content = NSMutableAttributedString(string:"")
                let attachment = NSTextAttachment()
                attachment.image = selectedPaymentOption.image
                attachment.bounds = CGRect(x:0, y: -3, width: 22.5, height: 15)
                
                let label = selectedPaymentOption.label
                
                let attachmentString = NSAttributedString(attachment: attachment)
                let textBrand = NSAttributedString(string: " \(label.prefix(label.count-4))")
                let textbetweenIcon = NSAttributedString(string:  " ending ", attributes: [NSAttributedString.Key.foregroundColor: Color(hex: "#D7D7D7")])
                let textLastFour = NSAttributedString(string: " \(label.suffix(4))")
                
                content.append(attachmentString)
                content.append(textBrand)
                content.append(textbetweenIcon)
                content.append(textLastFour)
                
                self.paymentMethod = content
            }
        }
    }
    
    func paymentContext(_ paymentContext: Stripe.STPPaymentContext, didCreatePaymentResult paymentResult: Stripe.STPPaymentResult, completion: @escaping Stripe.STPPaymentStatusBlock) {
        self.isLoading = true
        Task {
            await StripeManager.shared.createPaymentIntent { secert_key in
                if let secert_key {
                    let paymentIntentParams = STPPaymentIntentParams(clientSecret: secert_key)
                    paymentIntentParams.paymentMethodId = paymentResult.paymentMethod?.stripeId
                    
                    STPPaymentHandler.shared().confirmPayment(paymentIntentParams, with: paymentContext) { status, paymentIntent, error in
                        switch status {
                        case .succeeded:
                            print("SUCCESS!")
                            completion(.success, nil)
                        case .failed:
                            self.isLoading = false
                            completion(.error, error) // Report error
                        case .canceled:
                            self.isLoading = false
                            completion(.userCancellation, nil) // Customer cancelled
                        @unknown default:
                            self.isLoading = false
                            completion(.error, nil)
                        }
                        
                    }
                }
            }
        }
    }
    
    @MainActor func paymentContext(_ paymentContext: Stripe.STPPaymentContext, didFinishWith status: Stripe.STPPaymentStatus, error: (any Error)?) {
        switch status {
            case .error:
                self.isLoading = false
                if let _error = error {
                    let errormsg = _error.localizedDescription
                    self.alertManager?.callAlert(title: "Notice", message: errormsg)
                }
                return
            case .success:
                self.isLoading = false
                self.isShowComolete.toggle() // 可能要加時間
            case .userCancellation:
                self.isLoading = false
                return // Do nothing
        }
    }
}
