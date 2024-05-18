//
//  BannerSetModel.swift
//  CitySuper-Eshop clone
//
//  Created by LukeLin on 2024/5/11.
//

import Foundation

struct BannerSetModel: Decodable, Hashable {
    let id          : Int
    let image_src   : String?
    let link_type   : String?
    let related_id  : String?
    let youtube_id  : String?
    let banner_name : String?
    let external_url: String?
    var not_viewable: [String]?
}
