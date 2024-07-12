//
//  HomeViewModel.swift
//  CitySuper-Eshop clone
//
//  Created by LukeLin on 2024/5/11.
//

import Foundation

@MainActor final class HomeViewModel: ObservableObject {
    
    static let shared = HomeViewModel()
    
    @Published var isLoading     : Bool = false
    @Published var isShowSplashAD: Bool = false
    
    @Published var spalshAD: SplashAd?
    @Published var maquree: [MarqueeModel] = []
    @Published var banners: [[BannerSetModel]] = []
    @Published var popularCategory_List : PopularCategoryModel?
    @Published var popularCategory_Page : PopularCategoryModel?
    @Published var popularCategory_Plain: PopularCategoryModel?
    @Published var collectionNormalLayout_Normal: CollectionNormalLayoutModel?
    @Published var collectionNormalLayout_Linear: CollectionNormalLayoutModel?
    
    private var alertManager = AlertManager.shared
    
    func fetchHomepage() {
        
        guard !isLoading else { return }
        
        Task {
            do {
                self.isLoading = true
                let homeData = try await NetworkManager.shared.fetchHomePage()
                
                self.isLoading = false
                for data in homeData {
                    switch data.type {
                    case HomeModelType.splashAd.rawValue:
                        if let splashAd = data.splashAd {
                            if self.spalshAD == nil {
                                self.isShowSplashAD = true
                            }
                            self.spalshAD = splashAd
                        }
                    case HomeModelType.marquee.rawValue:
                        if let marquee = data.marquee {
                            self.maquree = marquee
                        }
                    case HomeModelType.bannerSets.rawValue:
                        if let banners = data.bannerSets {
                            self.banners.append(banners)
                        }
                        
                    case HomeModelType.popularCategory.rawValue:
                        if let popularCategory = data.popularCategory {
                            switch popularCategory.layout {
                            case HomePopularCategoryType.List.rawValue:
                                self.popularCategory_List = popularCategory
                                
                            case HomePopularCategoryType.Page.rawValue:
                                self.popularCategory_Page = popularCategory
                                
                            case HomePopularCategoryType.Plain.rawValue:
                                self.popularCategory_Plain = popularCategory
                                
                            default:
                                break
                            }
                        }
                        
                    case HomeModelType.collectionNormalLayout.rawValue:
                        if let collectionNormalLayout = data.collectionNormalLayout {
                            switch collectionNormalLayout.layout {
                            case HomeCollectionNormalLayoutType.Normal.rawValue:
                                self.collectionNormalLayout_Normal = collectionNormalLayout
                                
                            case HomeCollectionNormalLayoutType.Linear.rawValue:
                                self.collectionNormalLayout_Linear = collectionNormalLayout
                                
                            default:
                                break
                            }
                        }
                        
                    default:
                        break
                    }
                }
            } catch {
                self.isLoading = false
                if let error = error as? CSAlert {
                    alertManager.callErrorAlert(error)
                }
            }
        }
    }
}
