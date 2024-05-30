//
//  AddressViewModel.swift
//  Storefront
//
//  Created by Shopify.
//  Copyright (c) 2017 Shopify Inc. All rights reserved.
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to deal
//  in the Software without restriction, including without limitation the rights
//  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in
//  all copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
//  THE SOFTWARE.
//

import Foundation
import MobileBuySDK

final class AddressViewModel: ViewModel, Identifiable {
    
    typealias ModelType = Storefront.MailingAddress
    
    let model: ModelType
    
    let addressID:   String
    let firstName:   String
    let lastName:    String
    let phone:       String
    
    let address1:    String
    let address2:    String
    let city:        String
    let company:     String
    let country:     String
    let countryCode: String
    let province:    String
    let zip:         String
    
    var fullAddress: String {
        return " \(self.firstName) \(self.lastName),\n \(self.address1) \(self.address2),\n \(self.phone)"
    }
    
    // ----------------------------------
    //  MARK: - Init -
    //
    required init(from model: ModelType) {
        self.model       = model
        
        self.addressID   = model.id.rawValue
        self.firstName   = model.firstName ?? ""
        self.lastName    = model.lastName ?? ""
        self.phone       = model.phone ?? ""
        
        self.address1    = model.address1 ?? ""
        self.address2    = model.address2 ?? ""
        self.city        = model.city ?? "Hong Kong"
        self.company     = model.company ?? ""
        self.country     = model.country ?? "Hong Kong"
        self.countryCode = model.countryCodeV2?.rawValue ?? "HK"
        self.province    = model.province ?? "Hong Kong"
        self.zip         = model.zip ?? "00000"
    }
    
}

extension Storefront.MailingAddress: ViewModeling {
    typealias ViewModelType = AddressViewModel
}
