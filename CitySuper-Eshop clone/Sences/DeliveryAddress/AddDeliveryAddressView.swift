//
//  AddDeliveryAddressView.swift
//  CitySuper-Eshop clone
//
//  Created by LukeLin on 2024/5/29.
//

import SwiftUI

struct AddDeliveryAddressView: View {
    
    @State var firstName: String = ""
    @State var lastName : String = ""
    @State var company  : String = ""
    @State var address  : String = ""
    @State var district : String = ""
    @State var country  : String = ""
    @State var region   : String = ""
    @State var phone    : String = ""
    
    var body: some View {
        NavigationStack {
            VStack {
                CustomTextField(placeHolder: "Your first name", text: $firstName)
                
                CustomTextField(placeHolder: "Your last name", text: $lastName)

                CustomTextField(placeHolder: "Company(Optional)", text: $company)

                CustomTextField(placeHolder: "Address", text: $address)

                CustomTextField(placeHolder: "District", text: $district)

                HStack {
                    CustomTextField(placeHolder: "Country/Reggion", icon:"dropdown_icon", text: $country)
                    CustomTextField(placeHolder: "Region", icon:"dropdown_icon", text: $region)
                }
                
                CustomTextField(placeHolder: "Your phone number", text: $phone)
                
                Spacer()
                
                Button {
                    
                } label: {
                     ThemeButton(title: "Add")
                }
            }
            .padding()
            .navigationTitle("Delivery Address")
            .navigationBarTitleDisplayMode(.inline)
        }
        
    }
}

#Preview {
    AddDeliveryAddressView()
}
