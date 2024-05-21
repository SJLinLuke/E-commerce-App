//
//  ProgressView.swift
//  CitySuper-Eshop clone
//
//  Created by LukeLin on 2024/5/15.
//

import SwiftUI

struct Progress: View {
    
    @State private var progress  : CGFloat = 0.0
    @State private var frameWidth: CGFloat = 0.0
    
    var height      : CGFloat
    var figureTarget: CGFloat
    var color       : Color
    var isAnimated  : Bool = true
    
    let timer = Timer.publish(every: 0.02, on: .main, in: .common).autoconnect()
    
    var body: some View {
        ZStack(alignment: .leading) {
            GeometryReader(content: { geometry in
                Rectangle()
                    .frame(height: height)
                    .opacity(0.3)
                    .foregroundColor(.gray)
                    .cornerRadius(10)
                
                Rectangle()
                    .frame(width: min(progress, figureTarget) * geometry.size.width, height: height)
                    .foregroundColor(color)
                    .animation(isAnimated ? .easeInOut : .none, value: progress)
                    .cornerRadius(10)
            })
        }
        .frame(height: height)
        .onReceive(timer) { _ in
            if isAnimated {
                if progress < 1.0 {
                    progress += 0.01
                }
            } else {
                progress = figureTarget
            }
        }
    }
}

#Preview {
    Progress(height: 10,
             figureTarget: 0.5, color: .themeGreen)
}
