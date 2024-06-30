//
//  DeliveryView.swift
//  CitySuper-Eshop clone
//
//  Created by LukeLin on 2024/6/29.
//

import SwiftUI

struct DeliveryView: View {
    
    @EnvironmentObject private var cartEnv: CartEnvironment
    
    @StateObject private var DA_VM = DeliveryAddressViewModel.shared

    private let screenWidth = UIScreen.main.bounds.width * 0.9
     
    var body: some View {
        ScrollView {
            VStack(spacing: 0) {
                HStack {
                    Text("Delivery Address")
                        .font(.system(size: 16))
                        .fontWeight(.bold)
                    
                    Spacer()
                }
                .padding(.leading, 8)
                .padding(.vertical)
                
                ForEach(DA_VM.addresses.indices, id: \.self) { index in
                    DeliveryAddressTagView(address: DA_VM.addresses[index])
                        .onTapGesture {
                            cartEnv.currentSelectedAddress = DA_VM.addresses[index]
                        }
                    
                    if DA_VM.addresses[index] == DA_VM.addresses.last {
                        DeliveryNewAddressFormView()
                            .onTapGesture {
                                cartEnv.currentSelectedAddress = nil
                            }
                    }
                }
                
                if cartEnv.deliveryPicker {
                    HStack {
                        Text("Delivery time :")
                            .bold()
                        Text(cartEnv.currentSelectedDate.convertDataFormat(fromFormat: "yyyy-MM-dd", toFormat: "yyyy/MM/dd"))
                        Spacer()
                    }
                    .font(.system(size: 14))
                    .padding(EdgeInsets(top: 20, leading: 10, bottom: 10, trailing: 10))
                    
                    CalendarView(currentSelectedDate: $cartEnv.currentSelectedDate,
                                 startDate: cartEnv.deliveryStartDate,
                                 endDate: cartEnv.deliveryEndDate)
                }
                
                Button {
                    cartEnv.tapConfirm()
                } label: {
                    ThemeButton(title: "Confirm", width: screenWidth, disable: !cartEnv.deliveryPicker)
                        .padding(.top)
                }
            }
            .onAppear {
                DA_VM.fetchAddresses {
                    cartEnv.currentSelectedAddress = DA_VM.addresses.first
                }
            }
            .overlay {
                if DA_VM.isLoading { LoadingIndicatiorView() }
            }
        }
        .overlay {
            if cartEnv.isLoading { LoadingIndicatiorView(backgroundDisable: true) }
        }
    }
}

#Preview {
    DeliveryView()
        .environmentObject(CartEnvironment())
}
