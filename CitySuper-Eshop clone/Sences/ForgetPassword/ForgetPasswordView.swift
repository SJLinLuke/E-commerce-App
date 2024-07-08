//
//  ForgetPasswordView.swift
//  CitySuper-Eshop clone
//
//  Created by LukeLin on 2024/7/7.
//

import SwiftUI

struct ForgetPasswordView: View {
    
    @StateObject var VM = ForgetPasswordViewModel.shared
    
    @State var email: String = ""
    
    @Binding var isShow: Bool
    
    var body: some View {
        BaseStack {
            
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
                CustomTextField(placeHolder: "Email Address", text: $email)
            }
            .padding()
            
            Button {
                
            } label: {
                ThemeButton(title: "Submit")
            }
            .padding(.top)
            
            Spacer()
        }

    }
}

#Preview {
    ForgetPasswordView(isShow: .constant(true))
}
