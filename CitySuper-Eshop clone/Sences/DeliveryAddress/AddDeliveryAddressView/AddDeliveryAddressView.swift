//
//  AddDeliveryAddressView.swift
//  CitySuper-Eshop clone
//
//  Created by LukeLin on 2024/5/29.
//

import SwiftUI

struct AddDeliveryAddressView: View {
    
    @Environment(\.presentationMode) private var presentationMode
        
    @State private var buttonTitle: String = "Add"
    
    @StateObject private var VM = AddDeliveryAddressViewModel()
    
    var adderssInfo: AddressViewModel? = nil
    
    var body: some View {
        NavigationStack {
            VStack {
                CustomTextField(placeHolder: "Your first name", text: $VM.firstName)
                
                CustomTextField(placeHolder: "Your last name", text: $VM.lastName)

                CustomTextField(placeHolder: "Company(Optional)", text: $VM.company)

                CustomTextField(placeHolder: "Address", text: $VM.address)

                CustomTextField(placeHolder: "District", text: $VM.district)
             
                HStack {
                    CustomTextField(placeHolder: "Country/Reggion", 
                                    isDropDown: true,
                                    dropDownItem: ["Hong Kong"], text: $VM.country)
                    
                    CustomTextField(placeHolder: "Region", 
                                    isDropDown: true,
                                    dropDownItem: ["Hong Kong Island", "New Territories", "Kowloon"],
                                    text: $VM.region)
                }
                
                CustomTextField(placeHolder: "Your phone number", text: $VM.phone)
                    .keyboardType(.namePhonePad)
                
                Spacer()
                
                Button {
                    if buttonTitle == "Add" {
                        VM.addAddress()
                    } else {
                        VM.saveAddress(id: adderssInfo?.addressID ?? "")
                    }
                } label: {
                     ThemeButton(title: buttonTitle)
                }
            }
            .overlay {
                if VM.isLoading {
                    LoadingIndicatiorView()
                }
            }
            .padding()
            .navigationTitle("Delivery Address")
            .navigationBarTitleDisplayMode(.inline)
            .onAppear {
                if let adderssInfo = self.adderssInfo {
                    VM.setupAddressInfo(info: adderssInfo)
                    self.buttonTitle = "Save"
                }
            }
            .onReceive(VM.viewDismissPublisher) { shouldDismiss in
                if shouldDismiss {
                    self.presentationMode.wrappedValue.dismiss()
                }
            }
            .alert(VM.alertItem?.title ?? "", isPresented: $VM.isAlertShow, actions: {
                if let buttons = VM.alertItem?.buttons {
                    ForEach(buttons) { button in
                        Button(button.title, role: button.role, action: button.action)
                    }
                }
            }, message: {
                VM.alertItem?.message ?? Text("")
            })
        }
        
    }
}
//
//#Preview {
//    AddDeliveryAddressView()
//}
