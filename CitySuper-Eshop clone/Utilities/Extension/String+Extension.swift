//
//  String+Extension.swift
//  CitySuper-Eshop clone
//
//  Created by LukeLin on 2024/5/15.
//

import Foundation

extension String {
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
    
    var customFormat: String {
        let count = self.count
        return self.enumerated().map { $0.offset % 4 == 0 && $0.offset != 0 && $0.offset != count-1 || $0.offset == count-2 && count % 4 != 0 ? "-\($0.element)" : "\($0.element)" }.joined()
    }
    
    var shopifyIdEncode: String {
        
        if self.contains("gid:") {
            if let data = self.data(using: .utf8) {
                return data.base64EncodedString()
            }
        }
        
        return self
    }
    
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
