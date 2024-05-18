//
//  FavouritesEmptyView.swift
//  CitySuper-Eshop clone
//
//  Created by LukeLin on 2024/5/17.
//

import SwiftUI

struct FavouritesEmptyView: View {
    var body: some View {
        VStack {
            Image("tab_favourites")
                .resizable()
                .frame(width: 40, height: 40)
            
            Text("You do not have any favourites items")
                .font(.title3)
                .padding(.top, 40)
            
            Text("When you find some items that you can save them into favourites list.")
                .multilineTextAlignment(.center)
                .font(.title3)
                .foregroundColor(.secondary)
                .padding(.top, 20)

            Spacer()
                .frame(height: 270)
        }
    }
}

#Preview {
    FavouritesEmptyView()
}
