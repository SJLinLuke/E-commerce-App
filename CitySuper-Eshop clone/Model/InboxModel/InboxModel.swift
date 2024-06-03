//
//  InboxModel.swift
//  CitySuper-Eshop clone
//
//  Created by LukeLin on 2024/5/16.
//

import Foundation

struct MessageDetailResponse: Decodable {
    let success: Bool
    let error_message: String?
    let data: MessageDetailData?
}

struct MessageDetailData: Decodable {
    let id             : Int
    let read           : Bool
    let title          : String
    let content        : String
    let images_src     : [String]?
    let link_type      : String?
    let link_related_id: String?
    let external_url   : String?
    let publish_time   : String
    let expired        : Bool
    let button_text    : String?
}

struct InboxMessageResponse: Decodable {
    let success      : Bool
    let error_message: String?
    let data         : InboxMessageData?
}

struct InboxMessageData: Decodable {
    let current_page  : Int
    let first_page_url: String?
    let from          : Int?
    let data          : [InboxMessage]
    let last_page     : Int
    let last_page_url : String?
    let total         : Int
}

struct InboxMessage: Decodable, Identifiable, Equatable, Hashable {
    let id             : Int
    let publish_time   : String
    let title          : String
    let content        : String?
    let image_src      : [URL]?
    let thumbnail_src  : String?
    let link_type      : String?
    let link_related_id: String?
    let external_url   : String?
    var read           : Bool
}

struct UnreadResponse: Decodable {
    let success      : Bool
    let error_message: String?
    let data         : Int
}
