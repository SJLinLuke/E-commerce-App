//
//  Constants.swift
//  CitySuper-Eshop clone
//
//  Created by LukeLin on 2024/5/14.
//

import Foundation
import MobileBuySDK

struct Constants {
    
    static let shopDomain = "citysuper-mobile-dev.myshopify.com"
    static let apiKey = "d8984700447109bdeddf144b5eabbe26"
    
    static let client = Graph.Client(
        shopDomain: shopDomain,
        apiKey: apiKey,
        locale: Locale.current
    )
    
    static let host         = "https://mobileapiuat.citysuper.com.hk/public/"
    
    static let homepage     = "api/eshop/homepage?version=2"
    static let login        = "api/members/login"
    static let notification = "api/eshop/notifications?page="
    static let favourite    = "api/members/favouritedProducts?page="
    static let qrcode       = "api/members/qrcode?version=2"
    static let unread       = "api/eshop/notifications/unreadCount"
}
