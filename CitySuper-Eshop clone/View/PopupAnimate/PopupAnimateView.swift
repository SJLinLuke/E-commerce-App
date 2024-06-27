//
//  PopupAnimateView.swift
//  CitySuper-Eshop clone
//
//  Created by LukeLin on 2024/6/14.
//

import SwiftUI

enum PopViewType {
    case cart_add
    case favourite_add
    case favourite_remove
}

struct PopViewItem {
    let imagePath: String
    let title    : String
}

struct PopupAnimateView: View {
        
    @State var imageScale: CGFloat = 0
    @State var opcacity  : CGFloat = 0
    
    @Binding var isShow: Bool
    
    let type: PopViewType
    
    private var item: PopViewItem {
        switch type {
        case .cart_add:
            return PopViewItem(imagePath: "addtocart_popup", title: "Added to \nCart")
        case .favourite_add:
            return PopViewItem(imagePath: "favourite_popup", title: "Added to \nFavourites")
        case .favourite_remove:
            return PopViewItem(imagePath: "favourite_popup", title: "Removed from \nFavourites")
        }
    }
    
    var body: some View {
        ZStack {
            Color.gray.opacity(0.4)
                .edgesIgnoringSafeArea(.all)
                .disabled(true)
                .onTapGesture {}
            
            ZStack {
                Image(item.imagePath)
                    .resizable()
                    .frame(width: imageScale, height: imageScale)
                
                Text(item.title)
                    .font(.title3)
                    .fontWeight(.bold)
                    .fixedSize()
                    .multilineTextAlignment(.center)
                    .foregroundColor(.white)
                    .lineLimit(2)
                    .frame(width: 130)
                    .padding(.top, 65)
            }
            .opacity(opcacity)
            .onAppear {
                animate()
            }
        }
    }
    
    func animate() {
        withAnimation(Animation.bouncy) {
            opcacity = 1
            imageScale = 170
        } completion: {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                withAnimation(Animation.easeOut(duration: 0.3)) {
                    opcacity = 0
                    imageScale = 0
                    isShow = false
                }
            }
        }
    }
}

#Preview {
    PopupAnimateView(isShow: .constant(true) ,type: .cart_add)
}
