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
                NavigationLink { AddDeliveryAddressView(adderssInfo: address) } label: {
                    Text("Edit")
                        .foregroundColor(.themeGreen2)
                }
                
                Spacer()
                
                Button {
                    VM.alertItem = AlertContext.deliveryAddress_delete
                    VM.alertItem?.buttons.append(
                        AlertButton(title: "Delete",role: .destructive , action: {
                        VM.deleteAddress(address.addressID)
                    }))
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

//#Preview {
//    DeliveryAddressCell(address: AddressViewModel)
//}
