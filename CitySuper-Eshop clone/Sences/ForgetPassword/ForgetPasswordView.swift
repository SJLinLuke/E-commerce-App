//
//  ForgetPasswordView.swift
//  CitySuper-Eshop clone
//
//  Created by LukeLin on 2024/7/7.
//

import SwiftUI

struct ForgetPasswordView: View {
    
    @Environment(\.presentationMode) private var presentationMode
    
    @StateObject var VM = ForgetPasswordViewModel.shared
    @StateObject var alertManager = AlertManager()
    
    @Binding var isShow: Bool
    
    var body: some View {
        VStack {
            HStack {
                Spacer()
                XDismissButton(isShow: $isShow, color: .black)
            }
            .padding()
            
            Spacer()
                .frame(height: 150)
                
            Text("Forget Password")
                .font(.title2)
                .bold()
            
            Text("Please fill in your registered email address, to receive one-time password.")
                .font(.system(size: 16))
                .padding()
            
            VStack {
                HStack {
                    Text("Email Address")
                        
                    Spacer()
                }
                CustomTextField(placeHolder: "Email Address", text: $VM.email)
            }
            .padding()
            
            Button {
                VM.sendOTP()
            } label: {
                ThemeButton(title: "Submit")
            }
            .padding(.top)
            
            Spacer()
        }
        .onAppear {
            VM.alertManager = self.alertManager
        }
        .overlay {
            if VM.isLoading {
                LoadingIndicatiorView(backgroundDisable: true)
            }
        }
        .onReceive(VM.viewDismissPublisher) { shouldDismiss in
            if shouldDismiss {
                self.presentationMode.wrappedValue.dismiss()
            }
        }
    }
}

#Preview {
    ForgetPasswordView(isShow: .constant(true))
}
