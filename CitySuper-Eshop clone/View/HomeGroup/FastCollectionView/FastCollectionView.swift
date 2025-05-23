//
//  FastCollectionView.swift
//  CitySuper-Eshop clone
//
//  Created by LukeLin on 2024/5/12.
//

import SwiftUI

struct FastCollectionView: View {
        
    let popularCategories: [PopularCategory]

    @State private var currentIndex: Int = 0
    
    var body: some View {
        VStack {
            ZStack {
                ScrollViewReader { scrollView in
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack {
                            ForEach(popularCategories.indices, id: \.self) { index in
                                Text(popularCategories[index].title)
                                    .tag(index)
                                    .font(.system(size: 18))
                                    .fontWeight(popularCategories[index] == popularCategories[currentIndex] ? .semibold : .regular)
                                    .foregroundColor(popularCategories[index] == popularCategories[currentIndex] ? .black : .secondary)
                                    .padding(EdgeInsets(top: 10, leading: 15, bottom: 15, trailing: 15))
                                    .onTapGesture {
                                        withAnimation {
                                            currentIndex = index
                                        }
                                    }
                                    .overlay(alignment: .bottom) {
                                        if (popularCategories[index] == popularCategories[currentIndex]) {
                                            Spacer()
                                                .frame(height: 5)
                                                .background(Color(hex: "#46742D"))
                                        }
                                    }
                            }
                        }
                    }
                    .onChange(of: currentIndex, { prevIndex, currecntIndex in
                        withAnimation {
                            scrollView.scrollTo(scrollIndex(prevIndex, currentIndex))
                        }
                    })
                }
                .padding(.horizontal, 5)
            }
            .background(Color(hex: "F7F7F7"))
            
            TabView(selection: $currentIndex) {
                ForEach(popularCategories.indices, id: \.self) { index in
                    if let products = popularCategories[index].products {
                        ProductVGridView(products: products, isNeedDelete: false, itemWidth: 180, itemHeight: 280, meetLast: {})
                    }
                }
            }
            .tabViewStyle(.page(indexDisplayMode: .never))
            .padding(EdgeInsets(top: 10, leading: 0, bottom: -10, trailing: 0))
            
            Spacer()
            
            NavigationLink {
                ProductCollectionView(collectionID: popularCategories[currentIndex].shopify_collection_id)
            } label: {
                AllButton()
                    .padding(.vertical)
            }
            
        }
        .frame(height: 700)
    }
    func scrollIndex(_ prevIndex: Int, _ currentIndex: Int) -> Int {
        
        let middleIndex = (popularCategories.count / 2)
        
        if currentIndex == 0 {
            return 0
        }
        
        if currentIndex == popularCategories.count - 1 {
            return popularCategories.count - 1
        }
        
        if prevIndex > currentIndex {
            return currentIndex - 1
        }
        
        if prevIndex < currentIndex {
            return currentIndex + 1
        }
        return middleIndex
    }
    
}

#Preview {
    FastCollectionView(popularCategories: [PopularCategory(image_src: "", shopify_collection_id: "", title: "Beef", products: [ProductBody.mockData()])])
}
