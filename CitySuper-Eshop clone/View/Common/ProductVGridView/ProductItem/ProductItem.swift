//
//  ProductItem.swift
//  CitySuper-Eshop clone
//
//  Created by LukeLin on 2024/5/11.
//

import SwiftUI

struct ProductItem: View {
    
    let VM = ProductItemViewModel()
    
    let width       : CGFloat
    let height      : CGFloat
    let isNeedDelete: Bool
    
    @State private var selectedProductID: String?
    
    init(product: ProductBody, width: CGFloat, height: CGFloat, isNeedDelete: Bool) {
        VM.product        = product
        self.width        = width
        self.height       = height
        self.isNeedDelete = isNeedDelete
    }
    
    var body: some View {
        ZStack {
            Color(hex: "#F2F2F2")
            VStack(alignment: .leading) {
                RemoteImageView(url: VM.product?.image_src ?? "",
                                placeholder: .common)
                .frame(height: height / 1.6)
                
                Spacer()
                    .frame(width: width - 3, height: 1)
                    .overlay(alignment: .trailing) {
                        if (!isNeedDelete) {
                            FavouriteButton(isFavourite: VM.product?.is_favourite ?? false, width: 30, height: 30)
                        }
                    }
                
                Text(VM.product?.title ?? "")
                    .multilineTextAlignment(.leading)
                    .font(.caption)
                    .fontWeight(.semibold)
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
                            .foregroundColor(VM.isCompareWithPrice ? .red : .black )
                    }
                    
                    Spacer()
                    
                    if VM.isSoldOut {
                        SoldOutButton(width: 53, height: 25)
                    } else {
                        CartButton(width: 25, height: 25)
                    }
                }
                .padding(5)
            }
        }
        .onTapGesture {
            selectedProductID = VM.product?.shopify_product_id ?? ""
        }
        .navigationDestination(item: $selectedProductID, destination: { id in
            ProductDetailView(shopifyID: id)
        })
        .frame(width: width, height: height)
        .cornerRadius(10)
        .shadow(color: .gray, radius: 2, x: 0.5, y: 0.5)
        .padding(.leading, 3)
        .overlay(alignment:.topTrailing) {
            if (isNeedDelete) {
                ZStack {
                    Button {
                        print("tap delete!")
                    } label: {
                        Image("favourite_delete_icon")
                    }
                }
            }
        }
        
    }
}

#Preview {
    ProductItem(product: ProductBody(description_html: "", is_favourite: false, shopify_product_id: "", title: "1 Italian Veal Tongue [PreViously Frozen] (300g)", variants: nil, options: nil, logistic_tags: nil, image_src: "", inventory_quantity: 0, compare_at_price: nil, price: "69.99", images: nil, products: nil, similar_products: nil), width: 150, height: 240, isNeedDelete: false)
}

