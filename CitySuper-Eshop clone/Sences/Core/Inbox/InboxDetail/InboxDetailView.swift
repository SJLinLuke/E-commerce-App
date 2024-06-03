//
//  InboxDetailView.swift
//  CitySuper-Eshop clone
//
//  Created by LukeLin on 2024/5/27.
//

import SwiftUI

struct InboxDetailView: View {
    
    @StateObject var VM = InboxDetailViewModel()
    
    @State var htmlFrameHeight: CGFloat = .zero
    
    let notificationID: Int
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack {
                    if !VM.imageSrc.isEmpty {
                        RemoteImageView(url: VM.imageSrc, placeholder: .common)
                            .frame(height: 200)
                    }
                    
                    VStack {
                        HStack {
                            Text(VM.title)
                                .fontWeight(.bold)
                            Spacer()
                        }
                        
                        HStack {
                            Text(VM.publish_time)
                                .font(.system(size: 14))
                                .foregroundColor(.secondary)
                                .padding(.vertical)
                            Spacer()
                        }
                        
                        HTMLLoaderView(htmlFrameHeight: $htmlFrameHeight,
                                       htmlString: VM.htmlContent, source: Constants.inboxDetail_html_source)
                        .frame(height: htmlFrameHeight)
                        .padding(-10)
                        
                        if VM.isShowButton {
                            NavigationLink { routeToView(VM.inboxMessageDetail) } label: {
                                ThemeButton(title: VM.buttonTitle)
                                    .padding(.vertical)
                            }
                        }
                        
                        Spacer()
                    }
                    .padding()
                }
                .navigationTitle("Inbox")
                .navigationBarTitleDisplayMode(.inline)
            }
        }
        .overlay {
            if VM.isLoading {
                LoadingIndicatiorView()
            }
        }
        .task {
            VM.fetchInboxMessageDetail(id: notificationID)
        }
    }
    
    func routeToView(_ messageDetail: MessageDetailData?) -> AnyView? {
        guard let messageDetail = messageDetail else { return nil }
        switch messageDetail.link_type {
        case LinkType.PRODUCT.rawValue:
            if let id = messageDetail.link_related_id {
                return AnyView(ProductDetailView(shopifyID: id))
            }
        case LinkType.COLLECTION.rawValue:
            if let id = messageDetail.link_related_id {
                return AnyView(ProductCollectionView(collectionID: id, navTitle: ""))
            }
        case LinkType.ORDER.rawValue:
            if let id = messageDetail.link_related_id {
                return AnyView(OrderHistoryDetailView(orderID: id))
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
    InboxDetailView(notificationID: 11323)
}
