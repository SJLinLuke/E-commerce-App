//
//  VerifyView.swift
//  CitySuper-Eshop clone
//
//  Created by LukeLin on 2024/7/8.
//

import SwiftUI

struct VerifyView: View {
    
    @State var oneTimePassword: String = ""
    
    var body: some View {
        BaseStack {
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
                
            } label: {
                ThemeButton(title: "Submit")
            }
            .padding(.top)
            
            Button {
                
            } label: {
                 Text("Resend")
                    .underline()
                    .foregroundColor(.black)
                    .font(.callout)
            }
            .padding(.top)
            
            Spacer()
                .frame(height: 150)
        }
    }
}

#Preview {
    VerifyView()
}
