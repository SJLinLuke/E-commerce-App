//
//  AddDeliveryAddressViewModel.swift
//  CitySuper-Eshop clone
//
//  Created by LukeLin on 2024/5/29.
//

import Foundation
import MobileBuySDK
import Combine

@MainActor final class AddDeliveryAddressViewModel: ObservableObject {
    typealias Task = _Concurrency.Task
    
    static let shared = AddDeliveryAddressViewModel()
    
    @Published var isLoading  : Bool = false
    @Published var isAlertShow: Bool = false
    @Published var alertItem  : AlertItem? {
        didSet { self.isAlertShow = true }
    }
    
    @Published var firstName: String = ""
    @Published var lastName : String = ""
    @Published var company  : String = ""
    @Published var address  : String = ""
    @Published var district : String = ""
    @Published var country  : String = ""
    @Published var region   : String = ""
    @Published var phone    : String = ""
    
    var viewDismissPublisher = PassthroughSubject<Bool, Never>()
    private var shouldDismissView = false {
        didSet {
            viewDismissPublisher.send(shouldDismissView)
        }
    }
    
    
    func addAddress(complete: (() -> Void)? = nil) {
        
        guard !isLoading else { return }
        
        guard let input = self.creatInput() else {
            alertItem = AlertContext.deliveryAddress_fillForm
            return
        }
        
        Task {
            do {
                if let complete = complete {
                    let accessToken = try await NetworkManager.shared.getAccessToken()
                    
                    Client.shared.createAddress(input, with: accessToken) {
                        complete()
                    }
                } else {
                    self.isLoading = true
                    
                    let accessToken = try await NetworkManager.shared.getAccessToken()
                    
                    Client.shared.createAddress(input, with: accessToken) {
                        self.isLoading = false
                        self.shouldDismissView = true
                    }
                }
            } catch {
                print(error.localizedDescription)
                self.isLoading = false
            }
        }
        
    }
    
    func saveAddress(id: String) {
        
        guard !isLoading else { return }
        
        guard let input = self.creatInput() else {
            alertItem = AlertContext.deliveryAddress_fillForm
            return
        }
        
        Task {
            do {
                self.isLoading = true
                
                let accessToken = try await NetworkManager.shared.getAccessToken()
                
                Client.shared.udpateAddress(input, address_id: id, with: accessToken) {
                    self.isLoading = false
                    self.shouldDismissView = true
                }
            } catch {
                print(error.localizedDescription)
                self.isLoading = false
            }
        }
    }
    
    func creatInput(store: Locations? = nil) -> Storefront.MailingAddressInput? {
        
        if let store = store {
            return  Storefront.MailingAddressInput.create(
                        address1:  .value(store.address1),
                        address2:  .value(store.address2),
                        city:      .value("Hong Kong"),
                        company:   .value("Citysuper"),
                        country:   .value("Hong Kong"),
                        firstName: .value(store.name),
                        lastName:  .value("Citysuper"),
                        phone:     .value(""),
                        province:  .value("Hong Kong"),
                        zip:       .value("00000")
                   )
        }
        
        guard !firstName.isEmpty, !lastName.isEmpty, !address.isEmpty, !district.isEmpty, !country.isEmpty, !region.isEmpty, !phone.isEmpty else { return nil }
            
        return Storefront.MailingAddressInput.create(
                    address1:  .value(address),
                    address2:  .value(district),
                    city:      .value(region),
                    company:   .value(company),
                    country:   .value("Hong Kong"),
                    firstName: .value(firstName),
                    lastName:  .value(lastName),
                    phone:     .value(phone),
                    province:  .value("Hong Kong"),
                    zip:       .value("00000")
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
    
    func initInstantAddress() {
        self.firstName = ""
        self.lastName  = ""
        self.company   = ""
        self.address   = ""
        self.district  = ""
        self.country   = ""
        self.region    = ""
        self.phone     = ""
    }
}
