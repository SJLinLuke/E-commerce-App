//
//  LoadingIndicatiorView.swift
//  CitySuper-Eshop clone
//
//  Created by LukeLin on 2024/5/14.
//

import SwiftUI

struct LoadingIndicatiorView: View {
    
    //    var isShowing: Bool
    
    @State private var degree     : Int = 270
    @State private var spinnerLength = 0.6
    
    var body: some View {
        ZStack{
            Circle()
                .trim(from: 0.0,to: spinnerLength)
                .stroke(LinearGradient(colors: [.black,.gray], startPoint: .topLeading, endPoint: .bottomTrailing),style: StrokeStyle(lineWidth: 3.0,lineCap: .round,lineJoin:.round))
                .animation(Animation.easeIn(duration: 1.5).repeatForever(autoreverses: true))
                .frame(width: 55,height: 55)
                .rotationEffect(Angle(degrees: Double(degree)))
                .animation(Animation.linear(duration: 1).repeatForever(autoreverses: false))
                .onAppear{
                    degree = 270 + 360
                    spinnerLength = 0
                }
        }
        .frame(width: 70, height: 70)
        .background(Color.commonBackGroundGray)
        .cornerRadius(10)
        .shadow(radius: 40)
    }
}

struct Previews: PreviewProvider {
    static var previews: some View {
        LoadingIndicatiorView()
    }
}
