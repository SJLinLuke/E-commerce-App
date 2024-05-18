//
//  Binding+Extension.swift
//  CitySuper-Eshop clone
//
//  Created by LukeLin on 2024/5/15.
//

import SwiftUI

extension Binding where Value == Bool {
    
    // nagative bool binding same as `!Value`
    var not: Binding<Value> {
        Binding<Value> (
            get: { !self.wrappedValue },
            set: { self.wrappedValue = $0}
        )
    }
}
