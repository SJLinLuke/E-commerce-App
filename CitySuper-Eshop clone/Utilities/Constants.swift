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
    
    static let shopifyOrderIdHexFormat = "gid://shopify/Order/"
    
    static let client = Graph.Client(
        shopDomain: shopDomain,
        apiKey: apiKey,
        locale: Locale.current
    )
    
    static let host               = "https://mobileapiuat.citysuper.com.hk/public/"
    
    static let homepage           = "api/eshop/homepage?version=2"
    static let login              = "api/members/login"
    static let notification       = "api/eshop/notifications?page="
    static let notificationDetail = "api/eshop/notifications/"
    static let favourites         = "api/members/favouritedProducts?page="
    static let favourite          = "api/members/favouriteProduct"
    static let unfavourite        = "api/members/unfavouriteProduct"
    static let qrcode             = "api/members/qrcode?version=2"
    static let unread             = "api/eshop/notifications/unreadCount"
    static let multipassToken     = "api/members/multipassToken"
    static let orderInfos         = "api/eshop/order/orders"
    static let collection         = "api/eshop/collections/"
    static let product            = "api/eshop/products/"
    static let productSimilar     = "api/eshop/similarProducts/"
    static let productRelated     = "api/eshop/relatedProducts/"
    static let staticPage         = "api/eshop/staticPage?page="
    static let coupon             = "api/eshop/discounts?membercoupon=1"
    static let shoppingCart       = "api/eshop/shoppingCartProducts"
    static let navigations        = "api/eshop/navigations"
    static let suggestion         = "api/eshop/search/suggestion"
    static let summary            = "api/eshop/search/summary?keyword="
    static let searchProduct      = "api/eshop/search?keyword="
    static let searchList         = "api/eshop/search/collection?keyword="
    static let searchCollections  = "api/eshop/search/product_collection?keyword="
    
    static let productDetail_html_source = """
        <header><meta name='viewport' content='width=device-width,initial-scale=1.0, maximum-scale=1.0, minimum-scale=1.0'></header>
        <style> img {max-width:100%;height:auto !important;width:auto !important;} * {font-family: Helvetica} iframe{width: 100% !important;height: auto !important;}</style>
        """
    
    static let inboxDetail_html_source = "<header><meta name='viewport' content='width=device-width,initial-scale=1.0, maximum-scale=1.0, minimum-scale=1.0'></header><style> img {max-width:50%;height:auto !important;width:50% !important;} * {font-family: Helvetica} iframe{width: 100% !important;height: auto !important;}</style>"
    
    static let static_html_source = "<header><meta name='viewport' content='width=device-width,initial-scale=1.0, maximum-scale=1.0, minimum-scale=1.0'></header><style>*{font-family: Helvetica} iframe{width: 100% !important;height: auto !important;}</style>"
                                
    static let searchPrompt = "Search brand or product name"
}
