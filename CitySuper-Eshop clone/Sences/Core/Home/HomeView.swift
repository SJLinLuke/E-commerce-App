//
//  HomeView.swift
//  CitySuper-Eshop clone
//
//  Created by LukeLin on 2024/5/9.
//

import SwiftUI

struct HomeView: View {
    
    @StateObject var VM = HomeViewModel()
    
    @State private var searchText        : String = ""
    @State private var isShowingBackToTop: Bool = false
    @State private var isLoad            : Bool = true
    
    var body: some View {
        ScrollViewReader { scrollView in
            NavigationStack {
                ZStack {
                    Color(.commonBackGroundGray)
                    ScrollView {
                        VStack {
                            MaqureeView(maqureeItems: VM.maquree)
                                .id("top")
                            
                            if (VM.banners.indices.contains(0)) {
                                CarouselBannerView(bannerSets: VM.banners[0])
                                    .frame(height: 220)
                            }
                            
                            if let popularCategory_List = VM.popularCategory_List {
                                PopularCategoryView(popularCategories: popularCategory_List.categories)
                            }
                            
                            if (VM.banners.indices.contains(1)) {
                                CarouselBannerView(bannerSets: VM.banners[1],
                                                   indexDisplayMode: .never)
                                .frame(height: 120)
                            }
                            
                            if let collectionNormalLayout = VM.collectionNormalLayout_Normal {
                                CollectionNormalLayoutView_Normal(collectionNormalLayout: collectionNormalLayout)
                            }
                            
                            if (VM.banners.indices.contains(2)) {
                                CarouselBannerView(bannerSets: VM.banners[2],
                                                   indexDisplayMode: .never)
                                .frame(height: 170)
                            }
                            
                            if (VM.banners.indices.contains(3)) {
                                CarouselBannerView(bannerSets: VM.banners[3],
                                                   indexDisplayMode: .never)
                                .frame(height: 150)
                            }
                            
                            if let popularCategory_Page = VM.popularCategory_Page {
                                FastCollectionView(popularCategories:popularCategory_Page.categories)
                            }
                            
                            if (VM.banners.indices.contains(4)) {
                                CarouselBannerView(bannerSets: VM.banners[4],
                                                   indexDisplayMode: .never)
                                .frame(height: 170)
                            }
                            
                            if let popularCategory_Plain = VM.popularCategory_Plain {
                                PlainCollectionView(popularCategories: popularCategory_Plain.categories)
                            }
                        }
                        .background(GeometryReader { geometry in
                            Color.clear
                                .preference(key: ScrollOffsetPreferenceKey.self, value: geometry.frame(in: .named("scroll")).origin)
                        })
                        .onPreferenceChange(ScrollOffsetPreferenceKey.self) { value in
                            DispatchQueue.main.async {
                                withAnimation {
                                    if value.y < 120 {
                                        self.isShowingBackToTop = true
                                    } else {
                                        self.isShowingBackToTop = false
                                    }
                                }
                            }
                        }
                    }
                }
                .overlay {
                    if VM.isLoading {
                        LoadingIndicatiorView()
                    }
                }
                .task {
                    VM.fetchHomepage()
                }
                .modifier(NavigationModifier())
                .searchable(text: $searchText, placement: .navigationBarDrawer(displayMode: .always))
            }
            .overlay(alignment: .bottomTrailing) {
                Button {
                    withAnimation {
                        scrollView.scrollTo("top")
                    }
                } label: {
                    BackToTopButton(isShow: isShowingBackToTop)
                }
            }
            
        }
    }
}

#Preview {
    HomeView()
}
