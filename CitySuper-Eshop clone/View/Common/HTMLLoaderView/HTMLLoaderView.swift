//
//  HTMLLoaderView.swift
//  CitySuper-Eshop clone
//
//  Created by LukeLin on 2024/5/23.
//

import SwiftUI
import WebKit

struct HTMLLoaderView: UIViewRepresentable {
    
    @Binding var htmlFrameHeight: CGFloat
    var htmlString: String?
    var source: String
    
    func makeCoordinator() -> HTMLLoaderView.Coordinator {
        // connect coordinator
        Coordinator(self)
    }
    
    func makeUIView(context: Context) -> WKWebView {
        // init WKWebView config
        let config = WKWebViewConfiguration()
        let webView = WKWebView(frame: .zero, configuration: config)
        webView.navigationDelegate = context.coordinator
        webView.allowsBackForwardNavigationGestures = true
        webView.scrollView.isScrollEnabled = false
        return webView
    }
    
    func updateUIView(_ uiView: WKWebView, context: Context) {
        guard let htmlString = htmlString else { return }
        
        let source = source
        
        uiView.loadHTMLString("\(source)\(htmlString)", baseURL: nil)
    }
    
    class Coordinator: NSObject, WKNavigationDelegate {
        let parent: HTMLLoaderView
        
        init(_ parent: HTMLLoaderView) {
            self.parent = parent
        }
        
        func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
            webView.evaluateJavaScript("document.readyState") { (complete, error) in
                if complete != nil {
                    self.getHeight(webView: webView)
                }
            }
        }
        
        func getHeight(webView: WKWebView) {
            webView.evaluateJavaScript("document.documentElement.scrollHeight") { result, error in
                if let height = result as? CGFloat {
                    DispatchQueue.main.async {
                        self.parent.htmlFrameHeight = height
                    }
                } else if let error = error {
                    print("Failed to evaluate JavaScript: \(error.localizedDescription)")
                }
            }
        }
    }
}

#Preview {
    HTMLLoaderView(htmlFrameHeight: .constant(0), source: Constants.productDetail_html_source)
}
