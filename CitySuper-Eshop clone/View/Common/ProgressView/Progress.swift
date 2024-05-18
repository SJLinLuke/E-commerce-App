//
//  ProgressView.swift
//  CitySuper-Eshop clone
//
//  Created by LukeLin on 2024/5/15.
//

import SwiftUI

struct Progress: View {
    
    @EnvironmentObject var userEnv: UserEnviroment
    
    @State private var progress: CGFloat = 0.0
    
    var height      : CGFloat
    var figureTarget: CGFloat

    let timer = Timer.publish(every: 0.02, on: .main, in: .common).autoconnect()

     var body: some View {
       ZStack(alignment: .leading) {
         Rectangle()
           .frame(height: height)
           .opacity(0.3)
           .foregroundColor(.gray)
           .cornerRadius(10)

         Rectangle()
           .frame(width: progress * figureTarget, height: height)
           .foregroundColor(userEnv.isGoldMember ? .vipGold : .themeGreen)
           .animation(.easeInOut, value: progress)
           .cornerRadius(10)
       }
       .onReceive(timer) { _ in
         if progress < 1.0 {
           progress += 0.01
         }
       }
     }
}

#Preview {
    Progress(height: 10, figureTarget: 150)
        .environmentObject(UserEnviroment())
}
