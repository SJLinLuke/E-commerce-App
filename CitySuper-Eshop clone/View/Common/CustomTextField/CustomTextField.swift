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
    var icon         : String = ""
    
    @State var isHide        : Bool = false
    @State var isShowDropDown: Bool = false
    
    @Binding var text        : String
    
    var body: some View {
        ZStack {
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
                let shouldShowDropDown: Bool = isSecureField == false ?
                                                icon.isEmpty == false ?
                                                    true
                                                    :
                                                    false
                                               : false
                
                TextField(placeHolder, text: $text)
                    .overlay(alignment: .trailing) {
                        if isSecureField {
                            Image("password_icon_on")
                                .padding(.trailing, 8)
                                .onTapGesture {
                                    isHide = !isHide
                                }
                        } else {
                            if !icon.isEmpty {
                                Image(icon)
                                    .padding(.trailing, 8)
                            }
                        }
                    }
//                    .disabled(shouldShowDropDown)
                    .onTapGesture {
                        if shouldShowDropDown {
                            isShowDropDown.toggle()
                            print(isShowDropDown)
                        }
                    }
//                var dropDownItem: [String]  = ["item 1", "item 2", "item 3"]
//
//                            Menu {
//                               ForEach(dropDownItem, id: \.self){ item in
//                                   Button(item) {
////                                       self.value = item
//                                   }
//                               }
//                           } label: {
//                               VStack(spacing: 5){
//                                   Image(systemName: "chevron.down")
//                                       .font(.title3)
//                                       .fontWeight(.bold)
//                               }
//                           }

                    
                                         
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
