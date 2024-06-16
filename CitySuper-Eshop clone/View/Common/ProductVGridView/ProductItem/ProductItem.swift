//
//  ProductItem.swift
//  CitySuper-Eshop clone
//
//  Created by LukeLin on 2024/5/11.
//

import SwiftUI

struct ProductItem: View {
    
    @StateObject private var FavVM = FavouriteViewModel.shared
    
    @StateObject private var VM = ProductItemViewModel()
    
    let width       : CGFloat
    let height      : CGFloat
    let isNeedDelete: Bool
    let product     : ProductBody
    
    var body: some View {
        NavigationLink(destination: ProductDetailView(shopifyID: VM.product?.shopify_product_id ?? "")) {
            ZStack {
                Color(hex: "#F2F2F2")
                VStack(alignment: .leading) {
                    RemoteImageView(url: VM.getProductImageSrc(),
                                    placeholder: .common)
                    .frame(height: height / 1.6)
                    
                    Spacer()
                        .frame(width: width - 3, height: 1)
                        .overlay(alignment: .trailing) {
                            if (!isNeedDelete) {
                                FavouriteButton(
                                    isFavourite: $VM.isFavourite,
                                    product: VM.product ?? ProductBody.mockData(), width: 30, height: 30)
                            }
                        }
                    
                    Text(VM.product?.title ?? "")
                        .multilineTextAlignment(.leading)
                        .font(.caption)
                        .fontWeight(.semibold)
                        .foregroundColor(.black)
                        .padding(EdgeInsets(top: 15, leading: 10, bottom: 0, trailing: 5))
                    
                    Spacer()
                    
                    HStack(alignment: .bottom) {
                        VStack(alignment: .leading) {
                            if (VM.isCompareWithPrice) {
                                Text("\(Currency.stringFrom(Decimal(string: VM.product?.compare_at_price ?? "0") ?? 0.0))")
                                    .font(.caption)
                                    .strikethrough()
                                    .foregroundColor(.secondary)
                            }
                            
                            Text("\(Currency.stringFrom(Decimal(string: VM.product?.price ?? "0") ?? 0.0))")
                                .font(.caption)
                                .foregroundColor(VM.isCompareWithPrice ? Color(hex: "E85321") : .black )
                        }
                        .padding(EdgeInsets(top: 0, leading: 2, bottom: 2, trailing: 0))
                        
                        Spacer()
                        
                        if VM.isSoldOut {
                            SoldOutButton(width: 53, height: 25)
                        } else {
                            CartButton(width: 25, height: 25, shopifyID: VM.product?.shopify_product_id ?? "")
                        }
                    }
                    .padding(5)
                }
            }
            .frame(width: width, height: height)
            .cornerRadius(10)
            .shadow(color: .gray, radius: 2, x: 0.5, y: 0.5)
            .padding(.leading, 3)
            .onAppear {
                VM.product = product
            }
            .overlay(alignment:.topTrailing) {
                if (isNeedDelete) {
                    ZStack {
                        Button {
                            FavVM.removeFavourite(product: VM.product ?? ProductBody.mockData())
                            NotificationCenter.default.post(name: Notification.Name.RemoveFromFavourite_Popup, object: nil)
                        } label: {
                            Image("favourite_delete_icon")
                        }
                    }
                }
            }
        }
    }
}

#Preview {
    ProductItem(width: 150 , height: 240, isNeedDelete: false, product: ProductBody.mockData())
}

