//
//  ChangePasswordView.swift
//  CitySuper-Eshop clone
//
//  Created by LukeLin on 2024/7/10.
//

import SwiftUI

struct ChangePasswordView: View {
    
    @Environment(\.presentationMode) private var presentationMode
    
    @StateObject var VM = ChangePasswordViewModel()
    @StateObject var alertManager = AlertManager()
    
    @Binding var isShow: Bool
    
    let OldPassword: String

    var body: some View {
        NavigationStack {
            VStack {
                HStack {
                    Spacer()
                    XDismissButton(isShow: $isShow, color: .black)
                }
                .padding()
                
                Image("resetPassword_icon")
                    .resizable()
                    .frame(width: 130, height: 130)
                
                Text("Change Password")
                    .font(.title2)
                    .bold()
                    .padding(.top)
                
                Text("Password must be between 8-16 alphanumeric charactors long. It is case sensitive and must contain at least an uppercase letter, a lowercase letter, one number and one special charactor. For example, Cs123456#. This will be used for member zone and city'super HK App.")
                    .font(.system(size: 16))
                    .padding()
                
                VStack(spacing: 15) {
                    VStack {
                        HStack {
                            Text("Password")
                            Spacer()
                        }
                        CustomTextField(placeHolder: "Old Password", isSecureField: true, text: .constant(OldPassword))
                    }
                    
                    VStack(alignment: .leading) {
                        HStack {
                            Text("New Password")
                            Spacer()
                        }
                        CustomTextField(placeHolder: "",
                                        isSecureField: true,
                                        borderColor: VM.isPasswordValid(VM.newPassword) ? Color.gray : Color(hex: "E85321"),
                                        text: $VM.newPassword)
                        if !VM.isPasswordValid(VM.newPassword) {
                            Text("*The password format is incorrect")
                                .foregroundColor(Color(hex: "E85321"))
                        }
                    }
                    
                    VStack(alignment: .leading) {
                        HStack {
                            Text("Confirm New Password")
                            Spacer()
                        }
                        CustomTextField(placeHolder: "", 
                                        isSecureField: true,
                                        borderColor: VM.isPasswordMatch ? Color.gray : Color(hex: "E85321"),
                                        text: $VM.confirmNewPassword)
                        if !VM.isPasswordMatch {
                            Text("*The password is incorrect")
                                .foregroundColor(Color(hex: "E85321"))
                        }
                    }
                }
                .padding(.horizontal)
                
                Spacer()
                
                Button {
                    VM.updatePassword(password: OldPassword, newPassword: VM.newPassword)
                } label: {
                    ThemeButton(title: "Update")
                }
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
            .modifier(AlertModifier(alertItem: alertManager.alertItem, isAlertShow: $alertManager.isShowAlert))
        }
    }
}

#Preview {
    ChangePasswordView(isShow: .constant(true), OldPassword: "password")
}
