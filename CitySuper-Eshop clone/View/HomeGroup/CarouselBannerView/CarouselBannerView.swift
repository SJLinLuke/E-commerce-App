//
//  Banner.swift
//  CitySuper-Eshop clone
//
//  Created by LukeLin on 2024/5/11.
//

import SwiftUI

struct CarouselBannerView: View {
    private let timer = Timer.publish(every: 5, on: .main, in: .common).autoconnect()
    
    @State private var index = 0
    
    var bannerSets: [BannerSetModel] = []
    var indexDisplayMode: PageTabViewStyle.IndexDisplayMode?

    var body: some View {
        TabView(selection: $index) {
            ForEach(bannerSets.indices, id: \.self) { index in
                if let view = routeToView(bannerSets[index]) {
                    NavigationLink { view } label: {
                        RemoteImageView(url: bannerSets[index].image_src ?? "",
                                        placeholder: .common)
                            .tag(index)
                    }
                } else {
                    RemoteImageView(url: bannerSets[index].image_src ?? "",
                                    placeholder: .common)
                        .tag(index)
                }
            }
        }
        .tabViewStyle(.page(indexDisplayMode: indexDisplayMode ?? .always))
        .onReceive(timer) { _ in
            withAnimation {
                if (self.index == bannerSets.count) {
                    self.index = 0
                } else {
                    self.index += 1
                    if self.index > bannerSets.count - 1 {
                        self.index = 0
                    }
                }
            }
        }
    }
    
    func routeToView(_ bannerSetModel: BannerSetModel) -> AnyView? {
        switch bannerSetModel.link_type {
        case LinkType.PRODUCT.rawValue:
            if let id = bannerSetModel.related_id {
                return AnyView(ProductDetailView(shopifyID: id))
            }
        case LinkType.COLLECTION.rawValue:
            if let id = bannerSetModel.related_id {
                return AnyView(ProductCollectionView(collectionID: id, navTitle: ""))
            }
//        case LinkType.EXTERNAL_LINK.rawValue:
//            if let url = URL(string: bannerSetModel.external_url ?? "") {
//                return AnyView(SafariView(url: url))
//            } else {
//                return nil
//            }
        default:
            return nil
        }
        return nil
    }
}

#Preview {
    CarouselBannerView(bannerSets: [BannerSetModel(id: 0, image_src: "", link_type: "", related_id: "", youtube_id: "", banner_name: "", external_url: ""), BannerSetModel(id: 1, image_src: "", link_type: "", related_id: "", youtube_id: "", banner_name: "", external_url: "")])
}

enum LinkType: String {
    case PRODUCT       = "Product"
    case COLLECTION    = "Collection"
    case EXTERNAL_LINK = "ExternalLink"
    case ORDER         = "Order"
}
