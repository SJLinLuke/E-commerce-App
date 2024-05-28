//
//  DeliveryAddressViewModel.swift
//  CitySuper-Eshop clone
//
//  Created by LukeLin on 2024/5/28.
//

import Foundation

@MainActor final class DeliveryAddressViewModel: ObservableObject {
    
    @Published var isLoading: Bool = false
    @Published var addresses: [AddressViewModel] = []
    
    func fetchAddresses() {
        
        guard !isLoading else { return }
        
        Task {
            self.isLoading = true
            let mutipassToken = try await NetworkManager.shared.getMultipassToken()
            
            Client.shared.getCustomerAccessToken(with: mutipassToken) { access_token in
                if let access_token = access_token {
                    Client.shared.fetchCustomerAddresses(accessToken: access_token) { container in
                        if let container = container {
                            let rawAddresses = container.addresses.items
                            self.addresses = rawAddresses
                            self.isLoading = false
                        }
                    }
                }
            }
        }
    }
}
