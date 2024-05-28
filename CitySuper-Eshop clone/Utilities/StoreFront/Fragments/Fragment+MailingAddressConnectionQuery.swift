//
//  Fragment+MailingAddressConnectionQuery.swift
//  CitySuper-Eshop clone
//
//  Created by LukeLin on 2024/5/28.
//

import Foundation
import MobileBuySDK

extension Storefront.MailingAddressConnectionQuery {
    
    @discardableResult
    func fragmentForStandardAddress() -> Storefront.MailingAddressConnectionQuery { return self
        .pageInfo { $0
            .hasNextPage()
        }
        .nodes({ $0
            .id()
            .company()
            .address1()
            .address2()
            .firstName()
            .lastName()
            .phone()
            .company()
            .country()
            .countryCodeV2()
            .city()
            .province()
            .zip()
        })
    }
    
}
