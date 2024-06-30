//
//  DeliveryNewAddressFormView.swift
//  CitySuper-Eshop clone
//
//  Created by LukeLin on 2024/6/29.
//

import SwiftUI

struct DeliveryNewAddressFormView: View {
    @EnvironmentObject private var cartEnv: CartEnvironment

    @StateObject private var addDA_VM = AddDeliveryAddressViewModel()
    
    @State private var isSaveChecked: Bool = false
    
    var body: some View {
        HStack(spacing: 10) {
            VStack {
                Circle()
                    .frame(width: 15)
                    .foregroundColor(.clear)
                    .overlay {
                        RoundedRectangle(cornerRadius: 50)
                            .stroke(.secondary, lineWidth: 0.5)
                        if cartEnv.currentSelectedAddress == nil {
                            Circle()
                                .frame(width: 5.5)
                                .foregroundColor(.themeDarkGreen)
                        }
                    }
                    .shadow(radius: 10)
                    .padding(.leading, 10)
                    .padding(.top, 10)
                
                Spacer()
            }
            
            VStack {
                CustomTextField(placeHolder: "Your first name", text: $addDA_VM.firstName)
                CustomTextField(placeHolder: "Your last name", text: $addDA_VM.lastName)
                CustomTextField(placeHolder: "Company(Optional)", text: $addDA_VM.company)
                CustomTextField(placeHolder: "Address", text: $addDA_VM.address)
                CustomTextField(placeHolder: "District", text: $addDA_VM.district)
                HStack {
                    CustomTextField(placeHolder: "Country/Region", isDropDown: true, dropDownItem: ["Hong kong"], text: $addDA_VM.country)
                    CustomTextField(placeHolder: "Region", isDropDown: true, dropDownItem: ["Hong Kong Island", "New Territories", "Kowloon"], text: $addDA_VM.region)
                }
                CustomTextField(placeHolder: "Your phone number", text: $addDA_VM.phone)
                HStack {
                    Rectangle()
                        .frame(width: 20, height: 20)
                        .foregroundColor(.clear)
                        .overlay {
                            if isSaveChecked {
                                Image("checkbox_icon")
                            } else {
                                Rectangle()
                                    .stroke(Color(hex: "D2D2D2"), lineWidth: 1)
                            }
                        }
                        .onTapGesture {
                            isSaveChecked.toggle()
                        }
                    
                    Text("Save this information for next time")
                        .font(.system(size: 14))
                    Spacer()
                }
            }
        }
        .padding(EdgeInsets(top: 10, leading: 20, bottom: 10, trailing: 20))
    }
}

#Preview {
    DeliveryNewAddressFormView()
        .environmentObject(CartEnvironment())
}
