//
//  Array+Extention.swift
//  CitySuper-Eshop clone
//
//  Created by LukeLin on 2024/5/11.
//

import Foundation

extension Array {
    
}

extension [String] {
    func textViewFormat() -> String {
        return self.compactMap { $0 }.joined(separator: "\n")
    }
}
