//
//  DeliveryAddressViewModel.swift
//  CitySuper-Eshop clone
//
//  Created by LukeLin on 2024/5/28.
//

import Foundation

@MainActor final class DeliveryAddressViewModel: ObservableObject {
    
    static let shared = DeliveryAddressViewModel()
    
    @Published var isLoading  : Bool = false

    @Published var addresses: [AddressViewModel] = []
    
    func fetchAddresses(complete: (() -> Void)? = nil) {
        
        guard !isLoading else { return }
        
        Task {
            do {
                self.isLoading = true
                let accessToken = try await NetworkManager.shared.getAccessToken()
                
                Client.shared.fetchCustomerAddresses(accessToken: accessToken) { container in
                    if let container = container {
                        let rawAddresses = container.addresses.items
                        self.addresses = rawAddresses
                        self.isLoading = false
                        if let complete = complete {
                            complete()
                        }
                    }
                }
            } catch {
                self.isLoading = false
                print(error.localizedDescription)
            }
        }
        
    }
    
    func deleteAddress(_ addressID: String) {
        
        guard !isLoading else { return }
        
        Task {
            do {
                self.isLoading = true
                
                let accessToken = try await NetworkManager.shared.getAccessToken()
                
                Client.shared.deleteAddress(addressID, with: accessToken) {
                    self.removeAddress(addressID)
                    self.isLoading = false
                }
            } catch {
                self.isLoading = false
                print(error.localizedDescription)
            }
            
        }
    }
    
    private func removeAddress(_ addressID: String) {
        self.addresses = self.addresses.filter({ address in
            address.addressID != addressID
        })
    }
}
