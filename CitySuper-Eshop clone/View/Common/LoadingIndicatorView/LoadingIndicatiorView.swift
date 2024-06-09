//
//  LoadingIndicatiorView.swift
//  CitySuper-Eshop clone
//
//  Created by LukeLin on 2024/5/14.
//

import SwiftUI

struct LoadingIndicatiorView: View {
    
    @State private var degree     : Int = 270
    @State private var spinnerLength = 0.6
    
    var backgroundDisable: Bool = false
    
    var body: some View {
        ZStack {
            if backgroundDisable {
                Color.white.opacity(0.5)
                                .blur(radius: 10)
                                .edgesIgnoringSafeArea(.all)
                                .disabled(true)
                                .onTapGesture {}
            }
           
            ZStack {
                
                Circle()
                    .trim(from: 0.0, to: spinnerLength)
                    .stroke(
                        LinearGradient(colors: [.black, .gray], startPoint: .topLeading, endPoint: .bottomTrailing),
                        style: StrokeStyle(lineWidth: 1.8, lineCap: .round, lineJoin: .round)
                    )
                    .frame(width: 55, height: 55)
                    .rotationEffect(Angle(degrees: Double(degree)))
                    .onAppear {
                        startAnimations()
                    }
            }
            .frame(width: 70, height: 70)
            .background(Color.commonBackGroundGray.opacity(0.9))
            .cornerRadius(10)
            .shadow(radius: 40)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        
//
        
    }
    
    private func startAnimations() {
        withAnimation(Animation.linear(duration: 1).repeatForever(autoreverses: false)) {
            degree = 270 + 360
        }
        withAnimation(Animation.easeIn(duration: 1.5).repeatForever(autoreverses: true)) {
            spinnerLength = 0
        }
    }
}

struct Previews: PreviewProvider {
    static var previews: some View {
        LoadingIndicatiorView()
    }
}
