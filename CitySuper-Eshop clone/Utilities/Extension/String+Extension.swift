//
//  String+Extension.swift
//  CitySuper-Eshop clone
//
//  Created by LukeLin on 2024/5/15.
//

import Foundation
import SwiftUI

extension String {
    // Date formatter
    func convertDataFormat(fromFormat: String, toFormat: String) -> String {
        let sourceDateFormatter = DateFormatter()
            sourceDateFormatter.dateFormat = fromFormat
        
        let convertDateFormatter = DateFormatter()
            convertDateFormatter.dateFormat = toFormat
        
        if let sourceDate = sourceDateFormatter.date(from: self) {
            return convertDateFormatter.string(from: sourceDate)
        }
        
        return self
    }
    
    // This customFormat is for account number (eg. 1234-5678-9876-5432)
    var customFormat: String {
        let count = self.count
        return self.enumerated().map { $0.offset % 4 == 0 && $0.offset != 0 && $0.offset != count-1 || $0.offset == count-2 && count % 4 != 0 ? "-\($0.element)" : "\($0.element)" }.joined()
    }
    
    var shopifyIDEncode: String {
        
        if self.contains("gid:") {
            if let data = self.data(using: .utf8) {
                return data.base64EncodedString()
            }
        }
        
        return self
    }
    
    var shopifyIDDecode: String {
        do {
            if(!self.isEmpty){
                let decodedId = try Base64Decoder().decode(self)
                let gidSprs    : [String] = decodedId.components(separatedBy: Constants.shopifyOrderIdHexFormat)
                let gidSpr     : String   = gidSprs.count == 0 ? "" : gidSprs[1]
                let orderIdSprs: [String] = gidSpr.components(separatedBy: "?key")
                let orderId    : String?  = orderIdSprs.count == 0 ? "" : orderIdSprs[0]
                if let _orderId = orderId {
                    return _orderId
                }
            }
        } catch {
            print("Unable to Decode Base64 Encoded String \(error)")
        }
        
        return self
    }
    
    // Date expired check handling
    func isExpired() -> Bool {
        let today: Date = Date()
        let dateFormat = DateFormatter()
        let formet: String = "yyyyMMddHHmmss"
        dateFormat.locale = Locale(identifier: "en_US")
        dateFormat.dateFormat = formet
        guard let jsonDate: Date = dateFormat.date(from: self) else { return true }
        let jsonInterval: TimeInterval = jsonDate.timeIntervalSince1970
        return (jsonInterval - today.timeIntervalSince1970) <= 0
    }
}

struct Base64Decoder {
    enum DecodingError: Swift.Error {
        case invalidData
    }

    func decode(_ base64EncodedString: String) throws -> String {
        guard
            let base64EncodedData = base64EncodedString.data(using: .utf8),
            let data = Data(base64Encoded: base64EncodedData),
            let result = String(data: data, encoding: .utf8)
        else {
            throw DecodingError.invalidData
        }

        return result
    }

}
