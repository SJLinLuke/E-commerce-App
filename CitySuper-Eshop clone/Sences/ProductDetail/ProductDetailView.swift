//
//  ProductDetailView.swift
//  CitySuper-Eshop clone
//
//  Created by LukeLin on 2024/5/21.
//

import SwiftUI

struct ProductDetailView: View {
    
    @StateObject var VM = ProductDetailViewModel.shared
    
    @State var searchText: String = ""
    
    var shopifyID: String
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack {
                    ProductDetailImageGalleryView(images: VM.product?.images ?? [])
                    
                    GeometryReader(content: { geometry in
                        Spacer()
                            .frame(width: geometry.size.width - 15, height: 1)
                            .overlay(alignment: .trailing) {
                                FavouriteButton(isFavourite: true, width: 40, height: 40)
                            }
                            .padding(.top, -8)
                    })
                    
                    ProductDetailTitleView()
                    
                    ProductDetailTagsView()
                    
                    VStack(alignment: .leading) {
                        Rectangle()
                            .fill(.secondary)
                            .frame(height: 0.5)
                        
                        ProductDetailPriceView()
                        
                        Rectangle()
                            .fill(.secondary)
                            .frame(height: 0.5)
                        
                        ProductDetailBulletPointsView()
                        
                        Rectangle()
                            .fill(.secondary)
                            .frame(height: 0.5)
                        
                        HTMLView(htmlString: VM.product?.description_html ?? "")
                            .padding()
                            .frame(height: 400)
                    }
                    .padding()
                    
                    ProductDetailMoreProductsView(title: "Related Products",
                                                  products: VM.relatedProducts,
                                                  meetLast: {
                        VM.fetchRelatedProduct(shopifyID: shopifyID)
                    })
                    
                    Spacer()
                        .frame(height: 0)
                    
                    ProductDetailMoreProductsView(title: "Similar Products",
                                                  products: VM.similarProducts,
                                                  meetLast: {
                        VM.fetchSimilarProduct(shopifyID: shopifyID)
                    })
                }
                .onAppear {
                    VM.fetchProduct(shopifyID: shopifyID)
                }
                .onDisappear {
                    VM.product = nil
                }
            }
            .overlay {
                if VM.isLoading {
                    LoadingIndicatiorView()
                }
            }
            .modifier(NavigationModifier(isHideCollectionsList: true))
            .searchable(text: $searchText, placement: .navigationBarDrawer(displayMode: .always))
        }
    }
}

#Preview {
    ProductDetailView(shopifyID: "")
}

struct ProductDetailMoreProductsView: View {
    
    let title: String
    let products: [ProductBody]
    let meetLast: () -> Void
    
    var body: some View {
        ZStack {
            CollectionNormalLayoutView_Normal(
                collectionNormalLayout: CollectionNormalLayoutModel(title: title,
                                                                    layout: "",
                                                                    products: products,
                                                                    shopify_collection_id: ""),
                                                                    itemWidth: 175,
                                                                    itemHeight: 270,
                                                                    isRelatedSimilar: true, meetLast: {meetLast()})
            .background(Color(hex: "F2F2F2"))
        }
    }
}
import WebKit
struct HTMLView: UIViewRepresentable {
    typealias UIViewType = WKWebView
 
    // 4
    // Access the `homepage.html` file that is stored in the app bundle
    var fileURL: URL {
        guard let url = Bundle.main.url(forResource: "homepage", withExtension: "html") else {
            fatalError("path does not exist")
        }
        return url
    }
 
    /// Accepts a user HTML string e.g <p>SwiftUI is <b>awesome</b></p>
    var htmlString: String?
 
    func makeUIView(context: Context) -> WKWebView {
        // 5
        // Configure the WKWebView
        let config = WKWebViewConfiguration()
        let webView = WKWebView(frame: .zero, configuration: config)
        // 6
        // Part of the configuration is to allow for back-and-forth navigation between web pages.
        webView.allowsBackForwardNavigationGestures = true
        return webView
    }
 
    func updateUIView(_ uiView: WKWebView, context: Context) {
        guard let htmlString else {
            // 7
            // Load the `homepage.html` page (has CSS styling), refer to `styles.css`
            uiView.loadFileURL(fileURL, allowingReadAccessTo: fileURL)
            return
        }
        // 8
        // If the user passes an HTML string this page will be rendered
        let source = "<header><meta name='viewport' content='width=device-width,initial-scale=1.0, maximum-scale=1.0, minimum-scale=1.0'></header><style> img {max-width:100%;height:auto !important;width:auto !important;} * {font-family: Helvetica} iframe{width: 100% !important;height: auto !important;}</style>"
        uiView.loadHTMLString("\(source)\(htmlString)", baseURL: nil)
        uiView.scrollView.isScrollEnabled = false
    }
    

}
