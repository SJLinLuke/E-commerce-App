//
//  UserEnviroment.swift
//  CitySuper-Eshop clone
//
//  Created by LukeLin on 2024/5/14.
//

import SwiftUI

final class UserEnviroment: ObservableObject {
    
    @AppStorage("userData") private var storage_userData: Data?
    @AppStorage("qrcode") private var storage_qrcode    : Data?
    
    @Published var isLogin             : Bool   = false
    @Published var VAID                : String = ""
    @Published var token               : String = ""
    @Published var checkoutID          : String = ""
    @Published private var profile     : ProfileData?
    @Published var shopify_access_token: String = ""
    
    init() {
        if let storedUserData = storage_userData {
            self.retriveUser(storedUserData)
        }
    }
    
    var currentPassword: String = ""
    
    var memberName: String { self.profile?.englishName ?? "" }
    
    var isGoldMember: Bool { self.profile?.memberType != "SUPERE" }
    
    var asOfDate: String {
        self.profile?.asOfDate?.convertDataFormat(fromFormat: "yyyymmdd", toFormat: "yyyy/mm/dd") ?? ""
    }
    
    var anniversaryDate: String {
        self.profile?.anniversaryDate?.convertDataFormat(fromFormat: "yyyymmdd", toFormat: "yyyy/mm/dd") ?? ""
    }
    
    var loyaltyPoints: String { self.profile?.loyaltyPts ?? "0" }
    
    var accountNumber: String { self.profile?.accountNumber?.customFormat ?? "" }
    
    func setupUser(_ userData: LoginData) {
        isLogin    = true
        VAID       = userData.va_account
        token      = userData.token
        checkoutID = userData.current_checkout_id
        profile    = userData.profile
        
        saveUser(userData)
    }
    
    func storeShopifyAccessToken(_ token: String) {
        shopify_access_token = token
    }
        
    func removeUser() {
        isLogin              = false
        VAID                 = ""
        token                = ""
        checkoutID           = ""
        profile              = nil
        shopify_access_token = ""
        
        storage_userData = nil
        storage_qrcode   = nil
    }
    
    private func saveUser(_ userData: LoginData) {
        do {
            storage_userData = try JSONEncoder().encode(userData)
        } catch {
            print("something went wrong when encode user data.")
        }
    }
    
    private func retriveUser(_ storedUserData: Data) {
        do {
            let userData = try JSONDecoder().decode(LoginData.self, from: storedUserData)
            self.setupUser(userData)
        } catch {
            print("something went wrong when decode user data.")
        }
    }

}
