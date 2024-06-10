//
//  Login.swift
//  CitySuper-Eshop clone
//
//  Created by LukeLin on 2024/5/14.
//

import SwiftUI

struct LoginView: View {
    
    @EnvironmentObject private var userEnv: UserEnviroment
    @EnvironmentObject private var cartEnv: CartEnvironment
    
    @StateObject var VM = LoginViewModel()
    
    @State private var account: String = "wectestegold@hotmail.com"
    @State private var password: String = "Cs123456"
    
    @Binding var isShow: Bool
    
    var body: some View {
        VStack {
            HStack {
                Spacer()
                XDismissButton(isShow: $isShow, color: .black)
            }
            
            
            Spacer()
                .frame(height: 75)
            
            Image("bar_logo")
                .resizable()
                .frame(width: 137, height: 33)
            
            VStack(alignment: .leading, spacing: 8) {
                Text("Email Address")
                
                CustomTextField(placeHolder: "city'super membership login email", 
                                color: Color(hex: "F2F2F7"),
                                text: $account)
            }
            .padding(.top, 15)
            
            VStack(alignment: .leading, spacing: 8) {
                HStack {
                    Text("Password")
                    
                    Spacer()
                    
                    Button {
                        
                    } label: {
                        Text("Forgot password ?")
                            .foregroundColor(.black)
                            .underline()
                    }
                }
                
                CustomTextField(placeHolder: "Password",
                                isSecureField: true,
                                color: Color(hex: "F2F2F7"),
                                text: $password)
            }
            
            Spacer()
                .frame(height: 37)
            
            Button {
                VM.loginSever(loginData: LoginBody(username: self.account,password: self.password)) { isLogin in
                    if (isLogin) {
                        isShow = false
                    }
                }
            } label: {
                ThemeButton(title: "Login")
            }
            
            VStack(spacing: 10) {
                Text("Don't have an account")
                Button {
                    
                } label: {
                    Text("Register now")
                        .foregroundColor(.black)
                        .underline()
                }
            }
            .padding(.top, 20)
            
            Spacer()
            
        }
        .padding()
        .overlay {
            if(VM.isLoading) {
                LoadingIndicatiorView(backgroundDisable: true)
            }
        }
        .onAppear {
            VM.userEnv = self.userEnv
        }
        .onDisappear {
            if userEnv.isLogin {
                cartEnv.fetchCheckout(needAsync: false)
            }
        }
    }
}

#Preview {
    LoginView(isShow: .constant(true))
        .environmentObject(UserEnviroment())
}
