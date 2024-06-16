//
//  ProductVGridView.swift
//  CitySuper-Eshop clone
//
//  Created by LukeLin on 2024/5/13.
//

import SwiftUI


struct ProductVGridView: View {
    let colums = [GridItem(),GridItem()]
    
    let products    : [ProductBody]
    let isNeedDelete: Bool
    
    let itemWidth: Double
    let itemHeight: Double
    
    var meetLast: () -> Void
    
    var body: some View {
        LazyVGrid(columns: colums, spacing: 10) {
            ForEach(products, id: \.self) { product in
                ProductItem(width: itemWidth, height: itemHeight, isNeedDelete: isNeedDelete, product: product)
                    .onAppear {
                        if (products.last == product) {
                            meetLast()
                        }
                    }
                    .onTapGesture {
                        print(product.is_favourite)
                    }
            }
        }
    }
    
}


#Preview {
    ProductVGridView(products: [ProductBody.mockData()], isNeedDelete: false, itemWidth: 182, itemHeight: 270, meetLast: {print("meetLast")} )
}
