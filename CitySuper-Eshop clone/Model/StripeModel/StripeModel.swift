//
//  StripeModel.swift
//  CitySuper-Eshop clone
//
//  Created by LukeLin on 2024/7/14.
//

import Foundation

struct StripePaymentBody: Codable{
    let payment_intent_id: String
    let client_secret    : String
}

struct StripeResponse: Decodable {
    let success      : Bool
    let error_message: String?
    let data         : [String: Any]

    enum CodingKeys: String, CodingKey {
        case success
        case error_message
        case data
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        success = try container.decode(Bool.self, forKey: .success)
        error_message = try container.decodeIfPresent(String.self, forKey: .error_message)

        let dataContainer = try container.decode([String: AnyDecodable].self, forKey: .data)
        data = dataContainer.mapValues { $0.value }
    }
}

struct AnyDecodable: Decodable {
    let value: Any

    init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        
        if container.decodeNil() {
            value = NSNull()
        } else if let intValue = try? container.decode(Int.self) {
            value = intValue
        } else if let doubleValue = try? container.decode(Double.self) {
            value = doubleValue
        } else if let boolValue = try? container.decode(Bool.self) {
            value = boolValue
        } else if let stringValue = try? container.decode(String.self) {
            value = stringValue
        } else if let arrayValue = try? container.decode([AnyDecodable].self) {
            value = arrayValue.map { $0.value }
        } else if let dictionaryValue = try? container.decode([String: AnyDecodable].self) {
            value = dictionaryValue.mapValues { $0.value }
        } else {
            throw DecodingError.dataCorruptedError(in: container, debugDescription: "Cannot decode value")
        }
    }
}
