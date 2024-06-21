//
//  ProductBodyModel.swift
//  CitySuper-Eshop clone
//
//  Created by LukeLin on 2024/5/11.
//

import Foundation

struct SimilarRelatedProductResponse: Decodable {
    let success      : Bool
    let error_message: String?
    let data         : [ProductBody]
}

struct ProductResponse: Decodable {
    let success      : Bool
    let error_message: String?
    let data         : ProductBody
}

struct ProductBody: Decodable, Equatable, Hashable, Identifiable {
    var id = UUID()

    let description_html  : String?
    let is_favourite      : Bool
    let shopify_product_id: String
    let title             : String
    
    let variants          : [ProductVariant]?
    let options           : [ProductOption]?
    let logistic_tags     : [LogisticTag]?
    
    let image_src         : String?
    let inventory_quantity: Int?
    let compare_at_price  : String?
    let price             : String?
    
    let images            : [ProductImage]?
    
    /// these are not for using now (fetch by api/eshop/similarProducts/ and api/eshop/relatedProducts/)
    var products          : [ProductBody]? /// related products
    var similar_products  : [ProductBody]? /// similar products
    
    enum CodingKeys: CodingKey {
        case id
        case description_html
        case is_favourite
        case shopify_product_id
        case title
        case variants
        case options
        case logistic_tags
        case image_src
        case inventory_quantity
        case compare_at_price
        case price
        case images
        case products
        case similar_products
    }
    
    init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        self.description_html   = try container.decodeIfPresent(String.self, forKey: .description_html)
        self.is_favourite       = try container.decode(Bool.self, forKey: .is_favourite)
        self.shopify_product_id = try container.decode(String.self, forKey: .shopify_product_id)
        self.title              = try container.decode(String.self, forKey: .title)
        self.variants           = try container.decodeIfPresent([ProductVariant].self, forKey: .variants)
        self.options            = try container.decodeIfPresent([ProductOption].self, forKey: .options)
        self.logistic_tags      = try container.decodeIfPresent([LogisticTag].self, forKey: .logistic_tags)
        self.image_src          = try container.decodeIfPresent(String.self, forKey: .image_src)
        self.inventory_quantity = try container.decodeIfPresent(Int.self, forKey: .inventory_quantity)
        self.compare_at_price   = try container.decodeIfPresent(String.self, forKey: .compare_at_price)
        self.price              = try container.decodeIfPresent(String.self, forKey: .price)
        self.images             = try container.decodeIfPresent([ProductImage].self, forKey: .images)
        self.products           = try container.decodeIfPresent([ProductBody].self, forKey: .products)
        self.similar_products   = try container.decodeIfPresent([ProductBody].self, forKey: .similar_products)
    }
    
    init(
        id                : UUID = UUID(),
        description_html  : String? = nil,
        is_favourite      : Bool,
        shopify_product_id: String,
        title             : String,
        variants          : [ProductVariant]? = nil,
        options           : [ProductOption]? = nil,
        logistic_tags     : [LogisticTag]? = nil,
        image_src         : String? = nil,
        inventory_quantity: Int? = nil,
        compare_at_price  : String? = nil,
        price             : String? = nil,
        images            : [ProductImage]? = nil,
        products          : [ProductBody]? = nil,
        similar_products  : [ProductBody]? = nil
    ) {
        self.id                 = id
        self.description_html   = description_html
        self.is_favourite       = is_favourite
        self.shopify_product_id = shopify_product_id
        self.title              = title
        self.variants           = variants
        self.options            = options
        self.logistic_tags      = logistic_tags
        self.image_src          = image_src
        self.inventory_quantity = inventory_quantity
        self.compare_at_price   = compare_at_price
        self.price              = price
        self.images             = images
        self.products           = products
        self.similar_products   = similar_products
    }
        
    static func mockData() -> ProductBody {
        return ProductBody(
            description_html: "Mock Description",
            is_favourite: false,
            shopify_product_id: "mock_shopify_product_id",
            title: "Mock Product Title",
            variants: [],
            options: [],
            logistic_tags: [],
            image_src: "mock_image_src",
            inventory_quantity: 10,
            compare_at_price: "100.00",
            price: "80.00",
            images: [],
            products: [],
            similar_products: []
        )
    }
    //    func convertToProductViewModel() -> ProductViewModel? {
    //
    //        do {
    //            let type = try Storefront.Product(fields: [
    //                "id": shopify_product_id,
    //                "descriptionHtml":description_html ?? "",
    //                "title":title,
    ////                "variants": [Storefront.ProductVariantConnection(fields: [
    //////                    "id": UUID().uuidString,
    ////                    "shopify_product_id" : shopify_product_id,
    ////                    "descriptionHtml":description_html ?? "",
    ////                    "title":title,
    ////                ])],
    //                "variants" : "[]",
    //    //            "price":Decimal(string: price ?? "0"),
    //    //            "comparePrice": Decimal(string: compare_at_price ?? "0")
    //
    //            ])
    //            let model = ProductViewModel(from: type)
    //        return model
    //        }
    //        catch {
    //        print(error)
    //        }
    //
    //        return nil
    //    }
}

struct ProductOption: Codable, Equatable, Hashable {
    let shopify_product_option_id: Int?
    let name                     : String?
    let values                   : [String]?
}

struct LogisticTag: Codable, Equatable, Hashable {
    let bullet_point: String?
    let tag_name    : String
    let type        : String
}

struct ProductImage: Codable, Equatable, Hashable {
    let src     : String?
    let width   : Double
    let height  : Double
}

extension LogisticTag {
    var typeImage: String {
        var path: String = "store_icon"
        
        switch self.type {
            case "PickupOption":
                path = "pickuponly_icon"
            
            case "PickupOptionGeneral" :
                path = "pickuponly_icon"
            
            case "LeadtimeOption":
                path = "leadtime_icon"
            
            case "DeliveryOption":
                path = "deliveryonly_icon"
            
            case "ShipmentOption":
                path = "period_icon"
            
            case "ShipmentOptionGeneral":
                path = "period_icon"
            
            default:
                path = "store_icon"
        }
        return path
    }
}
