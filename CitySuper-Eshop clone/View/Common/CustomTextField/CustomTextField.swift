//
//  customTextField.swift
//  CitySuper-Eshop clone
//
//  Created by LukeLin on 2024/5/29.
//

import SwiftUI

struct CustomTextField: View {
    
    let placeHolder  : String
    var isSecureField: Bool = false
    var color        : Color = Color(hex: "F2F2F2")
    
    var isDropDown   : Bool = false
    var dropDownItem : [String] = []
    
    @State var isHide        : Bool = false
    @State var isShowDropDown: Bool = false
    
    @Binding var text        : String
    
    var body: some View {
        ZStack {
            if !isDropDown {
                if isSecureField && !isHide {
                    SecureField(placeHolder, text: $text)
                        .overlay(alignment: .trailing) {
                            Image(isHide ? "password_icon_on" : "password_icon")
                                .padding(.trailing, 8)
                                .onTapGesture {
                                    isHide = !isHide
                                }
                        }
                } else {
                    TextField(placeHolder, text: $text)
                        .overlay(alignment: .trailing) {
                            if isSecureField {
                                Image("password_icon_on")
                                    .padding(.trailing, 8)
                                    .onTapGesture {
                                        isHide = !isHide
                                    }
                            }
                        }
                }
            } else {
                Menu {
                    ForEach(dropDownItem, id: \.self){ item in
                        Button(item) {
                            text = item
                        }
                    }
                } label: {
                    HStack {
                        Text(text.isEmpty ? placeHolder : text)
                        
                        Spacer()
                        Image("dropdown_icon")
                    }
                    .foregroundColor(text.isEmpty ? Color(hex: "BEBEC0") : .black)
                }
            }
        }
        .padding(.horizontal, 10)
        .font(.subheadline)
        .frame(height: 35)
        .background(color)
        .overlay {
            RoundedRectangle(cornerRadius: 5)
                .stroke(Color.gray, lineWidth: 0.3)
        }
    }
}

#Preview {
    CustomTextField(placeHolder: "Test", text: .constant(""))
}
