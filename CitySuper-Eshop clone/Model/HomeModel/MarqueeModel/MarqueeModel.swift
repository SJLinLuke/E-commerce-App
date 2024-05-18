//
//  MarqueeModel.swift
//  CitySuper-Eshop clone
//
//  Created by LukeLin on 2024/5/11.
//

import Foundation

struct MarqueeModel: Decodable, Equatable, Hashable {    
    let external_url: String?
    let link_type   : String?
    let related_id  : String?
    let text        : String
    let text_colour : String
    var range       : NSRange?
}
