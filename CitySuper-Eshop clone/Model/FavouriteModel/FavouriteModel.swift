//
//  FavouriteModel.swift
//  CitySuper-Eshop clone
//
//  Created by LukeLin on 2024/5/18.
//

import Foundation

struct FavouriteResponse: Decodable{
    let success      : Bool
    let error_message: String?
    let data         : FavouriteData?
}

struct FavouriteData: Decodable {
    let current_page: Int
    let last_page   : Int?
    var data        : [ProductBody]
}
