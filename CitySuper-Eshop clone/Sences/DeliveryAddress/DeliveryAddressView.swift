//
//  DeliveryAddressView.swift
//  CitySuper-Eshop clone
//
//  Created by LukeLin on 2024/5/28.
//

import SwiftUI

struct DeliveryAddressView: View {
        
    @StateObject var VM = DeliveryAddressViewModel()
    
    var body: some View {
        NavigationStack {
            ScrollView {
                LazyVGrid(columns: [GridItem()]) {
                    ForEach(VM.addresses) { address in
                        DeliveryAddressCell(address: address)
                    }
                }
            }
            .navigationTitle("Delivery Address")
            .navigationBarTitleDisplayMode(.inline)
            .task {
                VM.fetchAddresses()
            }
            
            Button {
                
            } label: {
                ThemeButton(title: "Add New Address")
            }
            .padding(.bottom)
        }
        .overlay {
            if VM.isLoading {
                LoadingIndicatiorView()
            }
        }
    }
}

#Preview {
    DeliveryAddressView()
}
