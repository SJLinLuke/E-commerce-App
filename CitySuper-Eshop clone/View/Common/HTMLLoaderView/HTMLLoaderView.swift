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
        
        let source = """
        <header><meta name='viewport' content='width=device-width,initial-scale=1.0, maximum-scale=1.0, minimum-scale=1.0'></header>
        <style> img {max-width:100%;height:auto !important;width:auto !important;} * {font-family: Helvetica} iframe{width: 100% !important;height: auto !important;}</style>
        """
        
        uiView.loadHTMLString("\(source)\(htmlString)", baseURL: nil)
    }
    
    class Coordinator: NSObject, WKNavigationDelegate {
        let parent: HTMLLoaderView
        
        init(_ parent: HTMLLoaderView) {
            self.parent = parent
        }
       
        func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
            webView.evaluateJavaScript("document.body.scrollHeight", completionHandler: { (result, error) in
                if let height = result as? CGFloat {
                    DispatchQueue.main.async {
                        self.parent.htmlFrameHeight = height
                    }
                } else if let error = error {
                    print("Failed to evaluate JavaScript: \(error.localizedDescription)")
                }
                
            })
        }
    }
}

#Preview {
    HTMLLoaderView(htmlFrameHeight: .constant(100))
}
