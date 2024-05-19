//
//  Demical+Extension.swift
//  CitySuper-Eshop clone
//
//  Created by LukeLin on 2024/5/19.
//

import Foundation

extension Decimal {
    
    var formattedPrice: String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.minimumFractionDigits = 2
        formatter.maximumFractionDigits = 2
        return formatter.string(for: self) ?? "\(self)"
    }
}
