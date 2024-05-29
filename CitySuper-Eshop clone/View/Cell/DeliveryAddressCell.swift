//
//  DeliveryAddressCell.swift
//  CitySuper-Eshop clone
//
//  Created by LukeLin on 2024/5/29.
//

import SwiftUI

struct DeliveryAddressCell: View {
    
    @StateObject var VM = DeliveryAddressViewModel.shared
    
    let address: AddressViewModel
    
    var body: some View {
        HStack {
            Text(address.fullAddress)
                .padding(.leading, 10)
                .fontWeight(.medium)
                .multilineTextAlignment(.leading)
            
            Spacer()
            
            VStack {
                Button {
                    print("edit")
                } label: {
                    Text("Edit")
                        .foregroundColor(.themeGreen2)
                }
                
                Spacer()
                
                Button {
                    VM.alertItem = AlertContext.deliveryAddress_delete
                    VM.alertItem?.dismissButton = .default(Text("Ok"), action: {
                        VM.deleteAddress(address.addressID)
                        print(address.addressID)
                    })
                } label: {
                    Text("Delete")
                        .foregroundColor(.gray)
                }
            }
            .padding(.vertical)
            .padding(.trailing, 10)
            
        }
        .frame(height: 80)
        .font(.footnote)
        .background(Color(hex: "FFFFFF"))
        .cornerRadius(8)
        .shadow(color: .secondary, radius: 3, x: 0, y: 0)
        .padding(EdgeInsets(top: 10, leading: 20, bottom: 5, trailing: 20))
        .alert(item: $VM.alertItem, content: { alert in
            Alert(title: alert.title,
                  message: alert.message,
                  dismissButton: alert.dismissButton)
        })
    }
}

//#Preview {
//    DeliveryAddressCell(address: AddressViewModel)
//}
