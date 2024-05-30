//
//  AddDeliveryAddressViewModel.swift
//  CitySuper-Eshop clone
//
//  Created by LukeLin on 2024/5/29.
//

import Foundation
import MobileBuySDK

@MainActor final class AddDeliveryAddressViewModel: ObservableObject {
    
    @Published var isLoading: Bool = false
    
    @Published var firstName: String = ""
    @Published var lastName : String = ""
    @Published var company  : String = ""
    @Published var address  : String = ""
    @Published var district : String = ""
    @Published var country  : String = ""
    @Published var region   : String = ""
    @Published var phone    : String = ""
    
    func addAddress() async {
        
        guard !isLoading else { return }
        
        guard let input = self.creatInput() else { return } // alert : fill up form
        
        do {
            self.isLoading = true
            
            let mutipassToken = try await NetworkManager.shared.getMultipassToken()
            
            Client.shared.getCustomerAccessToken(with: mutipassToken) { access_token in
                if let access_token = access_token {
                    Client.shared.createAddress(input, with: access_token) {
                        print("success")
                        self.isLoading = false
                    }
                } else {
                    self.isLoading = false
                }
            }
        } catch {
            print(error.localizedDescription)
            self.isLoading = false
        }
    }
    
    func saveAddress(id: String) async {
        
        guard !isLoading else { return }
        
        guard let input = self.creatInput() else { return } // alert : fill up form
        
        do {
            self.isLoading = true
            
            let mutipassToken = try await NetworkManager.shared.getMultipassToken()
            
            Client.shared.getCustomerAccessToken(with: mutipassToken) { access_token in
                if let access_token = access_token {
                    Client.shared.udpateAddress(input, address_id: id, with: access_token) {
                        print("success")
                    }
                } else {
                    self.isLoading = false
                }
            }
        } catch {
            print(error.localizedDescription)
            self.isLoading = false
        }
    }
    
    private func creatInput() -> Storefront.MailingAddressInput? {
        
        guard !firstName.isEmpty, !lastName.isEmpty, !address.isEmpty, !district.isEmpty, !country.isEmpty, !region.isEmpty, !phone.isEmpty else { return nil }
            
        return Storefront.MailingAddressInput.create(
                    address1: .value(address),
                    address2: .value(district),
                    city: .value(region),
                    company: .value(company),
                    country: .value(country),
                    firstName: .value(firstName),
                    lastName: .value(lastName),
                    phone: .value(phone),
                    province: .value("Hong Kong"),
                    zip: .value("00000")
               )
    }
    
    func setupAddressInfo(info: AddressViewModel) {
        self.firstName = info.firstName
        self.lastName  = info.lastName
        self.company   = info.company
        self.address   = info.address1
        self.district  = info.address2
        self.country   = info.country
        self.region    = info.city
        self.phone     = info.phone
    }
    
    func printData() {
        print(firstName)
        print(lastName)
        print(company)
        print(address)
        print(district)
        print(country)
        print(region)
        print(phone)
    }
}
