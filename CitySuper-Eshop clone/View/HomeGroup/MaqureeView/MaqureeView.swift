//
//  Maquree.swift
//  CitySuper-Eshop clone
//
//  Created by LukeLin on 2024/5/10.
//

import SwiftUI

struct MaqureeView: View {
    
    let maqureeItems: [MarqueeModel]
    
    var body: some View {
        return ScrollView(.horizontal, showsIndicators: false) {
             HStack {
                 ForEach(maqureeItems, id: \.self) { maquree in
                     if maquree == maqureeItems.first {
                         Button(action: {
//                             print("tapped1")
                         }, label: {
                             Text(maquree.text)
                                 .font(.callout)
                                 .foregroundColor(Color(hex: maquree.text_colour))
                         })
                     } else {
                         Text(" | ")
                         Button(action: {
//                             print("tapped2")
                         }, label: {
                             Text(maquree.text)
                                 .font(.callout)
                                 .foregroundColor(Color(hex: maquree.text_colour))
                         })
                     }
                 }
             }.marquee(duration: 30)
         }
        
     }
 }

#Preview {
    MaqureeView(maqureeItems: [MarqueeModel(external_url: "", link_type: "", related_id: "", text: "This is test message.", text_colour: "")])
}

struct maqureeItem: Identifiable, Equatable {
    let id = UUID()
    let type: String
    let content: Text
}
