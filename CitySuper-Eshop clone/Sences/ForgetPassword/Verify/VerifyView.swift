//
//  VerifyView.swift
//  CitySuper-Eshop clone
//
//  Created by LukeLin on 2024/7/8.
//

import SwiftUI

struct VerifyView: View {
    
    @Environment(\.presentationMode) private var presentationMode
    
    @StateObject private var ForgetPW_VM = ForgetPasswordViewModel.shared
    @StateObject private var alertManager = AlertManager()
    
    @State var oneTimePassword: String = ""
    
    @Binding var isShow: Bool
    
    var body: some View {
        NavigationStack {
            VStack {
                HStack {
                    Spacer()
                    XDismissButton(isShow: $isShow, color: .black)
                }
                .padding()
                
                Spacer()
                    .frame(height: 50)
                
                Image("email_icon")
                    .resizable()
                    .frame(width: 130, height: 130)
                
                Text("Check your email")
                    .font(.title2)
                    .bold()
                
                Text("The 6-ditgit one-time password has been sent to your registered email.\n(Please also check junk folder)")
                    .font(.system(size: 16))
                    .padding()
                
                VStack {
                    HStack {
                        Text("Enter one-time password")
                        
                        Spacer()
                    }
                    CustomTextField(placeHolder: "One-time password", text: $oneTimePassword)
                }
                .padding()
                
                Button {
                    ForgetPW_VM.resetRandomPassword(otp: oneTimePassword)
                } label: {
                    ThemeButton(title: "Submit")
                }
                .padding(.top)
                
                Button {
                    ForgetPW_VM.sendOTP(resend: true)
                } label: {
                    let resendText = ForgetPW_VM.isResendDisabled ? "Resend (\(ForgetPW_VM.countdown)s)" : "Resend"
                    Text(resendText)
                        .underline()
                        .foregroundColor(ForgetPW_VM.isResendDisabled ? .gray : .black )
                        .font(.callout)
                }
                .disabled(ForgetPW_VM.isResendDisabled)
                .padding(.top)
                
                Spacer()
            }
            .overlay {
                if ForgetPW_VM.isLoading {
                    LoadingIndicatiorView(backgroundDisable: true)
                }
            }
            .onAppear {
                ForgetPW_VM.startTimer()
                ForgetPW_VM.alertManager = self.alertManager
            }
            .onReceive(ForgetPW_VM.viewDismissPublisher) { shouldDismiss in
                if shouldDismiss {
                    self.presentationMode.wrappedValue.dismiss()
                }
            }
            .modifier(AlertModifier(alertItem: alertManager.alertItem, isAlertShow: $alertManager.isShowAlert))
        }
    }
}

#Preview {
    VerifyView(isShow: .constant(true))
}
