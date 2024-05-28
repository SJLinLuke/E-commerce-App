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
                        HStack {
                            Text(address.fullAddress)
                                .padding(.leading, 10)
                                .fontWeight(.medium)
                                .multilineTextAlignment(.leading)
                            
                            Spacer()
                            
                            VStack {
                                Button {
                                    
                                } label: {
                                    Text("Edit")
                                        .foregroundColor(.themeGreen2)
                                }
                                
                                Spacer()
                                
                                Button {
                                    
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
                    }
                }
            }
            .navigationTitle("Delivery Address")
            .navigationBarTitleDisplayMode(.inline)
            .onAppear {
                VM.fetchAddresses()
            }
            
            Button {
                
            } label: {
                ThemeButton(title: "Add New Address")
            }
            .padding(.bottom)
        }
    }
}

#Preview {
    DeliveryAddressView()
}
