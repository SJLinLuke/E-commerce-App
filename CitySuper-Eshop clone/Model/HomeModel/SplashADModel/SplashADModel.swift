//
//  SplashADModel.swift
//  CitySuper-Eshop clone
//
//  Created by LukeLin on 2024/5/11.
//

import Foundation

struct SplashAd: Decodable {
    let id          : Int
    let image_src   : String?
    let link_type   : String?
    let related_id  : String?
    let youtube_id  : String?
    let external_url: String?
}
