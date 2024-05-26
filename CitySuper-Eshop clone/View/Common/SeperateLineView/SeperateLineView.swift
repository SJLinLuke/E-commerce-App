//
//  SeperateLineView.swift
//  CitySuper-Eshop clone
//
//  Created by LukeLin on 2024/5/25.
//

import SwiftUI

struct SeperateLineView: View {
    
    var color: Color   = .secondary
    var height: Double = 0.3
    var width: Double = .infinity
    
    var body: some View {
        Rectangle().fill(color).frame(width: width, height: height)
    }
}

#Preview {
    SeperateLineView()
}
