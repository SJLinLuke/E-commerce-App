//
//  HomeModel.swift
//  CitySuper-Eshop clone
//
//  Created by LukeLin on 2024/5/11.
//

import Foundation

enum HomeModelType: String {
    case splashAd               = "SplashAd"
    case marquee                = "Marquee"
    case popularCategory        = "PopularCategories"
    case bannerSets             = "BannerSet"
    case collectionNormalLayout = "Collection"
}

enum HomePopularCategoryType: String {
    case List  = "ListLayout"
    case Plain = "PlainLayout"
    case Page  = "PageLayout"
}

enum HomeCollectionNormalLayoutType: String {
    case Normal = "NormalLayout"
    case Linear = "LinearLayout"
}

struct HomePageResponse: Decodable {
    let success      : Bool
    let error_message: String?
    let data         : [HomePageModule]
}

struct HomePageModule: Decodable {
   
    var type                  :String? = nil
    var isHidden              :Bool = false
    var splashAd              :SplashAd? = nil
    var marquee               :[MarqueeModel]? = nil
    var popularCategory       :PopularCategoryModel? = nil
    var bannerSets            :[BannerSetModel]? = nil
    var collectionNormalLayout:CollectionNormalLayoutModel? = nil
    
    enum CodingKeys:String, CodingKey{
        case type                   = "type"
        case splashAd               = "splash_ad"
        case marquee                = "messages"
        case popularCategory        = "popular_categories"
        case bannerSets             = "banner_set"
        case collectionNormalLayout = "collection"
    }
    
    init(from decoder: Decoder) throws {
        
        let values = try decoder.container(keyedBy: CodingKeys.self)
        
        self.type = try values.decode(String.self, forKey: .type)
        
        switch self.type {
            
        case "SplashAd":
            self.splashAd = try values.decodeIfPresent(SplashAd.self, forKey: .splashAd)
            
        case "Marquee":
            self.marquee = try values.decodeIfPresent([MarqueeModel].self, forKey: .marquee)
            
        case "PopularCategories":
            self.popularCategory = try values.decodeIfPresent(PopularCategoryModel.self, forKey: .popularCategory)
            
        case "BannerSet":
            self.bannerSets = try values.decodeIfPresent([BannerSetModel].self, forKey: .bannerSets)
            
        case "Collection":
            self.collectionNormalLayout = try values.decodeIfPresent(CollectionNormalLayoutModel.self, forKey: .collectionNormalLayout)
            
        default:
            break
        }
    }
}
