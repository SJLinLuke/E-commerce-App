//
//  StaticPageModel.swift
//  CitySuper-Eshop clone
//
//  Created by LukeLin on 2024/6/1.
//

import Foundation

struct StaticPageResponse: Decodable {
    let success      : Bool
    let error_message: String?
    let data         : StaticPageData
}

struct StaticPageData: Decodable {
    let pageContent  : String
}
