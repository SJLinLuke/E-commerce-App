//
//  FavouriteButton.swift
//  CitySuper-Eshop clone
//
//  Created by LukeLin on 2024/5/21.
//

import SwiftUI

struct FavouriteButton: View {
    
    @StateObject private var FavVM = FavouriteViewModel.shared
    
    @Binding var isFavourite: Bool
    
    let product: ProductBody
    var width  : CGFloat
    var height : CGFloat

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
            if isFavourite {
                FavVM.addFavourite(product: product)
                NotificationCenter.default.post(name: Notification.Name.addToFavourite_Popup, object: nil)
            } else {
                FavVM.removeFavourite(product: product)
                NotificationCenter.default.post(name: Notification.Name.RemoveFromFavourite_Popup, object: nil)
            }
        }
    }
}

#Preview {
    FavouriteButton(isFavourite: .constant(true), product: ProductBody.mockData(), width: 50, height: 50)
}
