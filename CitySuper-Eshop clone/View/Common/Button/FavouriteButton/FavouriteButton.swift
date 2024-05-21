//
//  FavouriteButton.swift
//  CitySuper-Eshop clone
//
//  Created by LukeLin on 2024/5/21.
//

import SwiftUI

struct FavouriteButton: View {
    
    @State var isFavourite: Bool
    var width : CGFloat
    var height: CGFloat
    
    init(isFavourite: Bool, width: CGFloat, height: CGFloat) {
        self.isFavourite = isFavourite
        self.width = width
        self.height = height
    }
    
    var body: some View {
        ZStack {
            Circle()
                .foregroundColor(.clear)
                .frame(width: width, height: height)
                .shadow(color: .gray, radius: 0.5, x: 0, y: 0.5)
            
            if isFavourite {
                Image("favourites_icon_on")
                    .resizable()
                    .frame(width: width, height: height)
            } else {
                Image("favourites_icon")
                    .resizable()
                    .frame(width: width, height: height)
            }
        }
        .onTapGesture {
            isFavourite = !isFavourite
        }
    }
}

#Preview {
    FavouriteButton(isFavourite: true, width: 50, height: 50)
}
