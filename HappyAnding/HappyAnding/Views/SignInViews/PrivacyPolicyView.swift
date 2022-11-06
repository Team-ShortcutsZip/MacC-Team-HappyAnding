//
//  PrivacyPolicyView.swift
//  HappyAnding
//
//  Created by 이지원 on 2022/11/07.
//

import Combine
import SwiftUI
import WebKit


class WebViewModel: ObservableObject {
    @Published var isLoading = false
}


struct PrivacyPolicyView: UIViewRepresentable {
    
    @ObservedObject var webViewModel: WebViewModel
    
    let privacyPolicyURL = "https://noble-satellite-574.notion.site/60d8fa2f417c40cca35e9c784f74b7fd"
    let webView = WKWebView()
    
    func makeCoordinator() -> PrivacyPolicyView.Coordinator {
        Coordinator(self, webViewModel)
    }
    
    func makeUIView(context: Context) -> WKWebView {
        
        if let url = URL(string: self.privacyPolicyURL) {
            webView.navigationDelegate = context.coordinator
            self.webView.load(URLRequest(url: url))
        }
        return webView
    }
    
    func updateUIView(_ uiView: WKWebView,
                      context: UIViewRepresentableContext<PrivacyPolicyView>) {
        return
    }
}

extension PrivacyPolicyView {
    
    class Coordinator: NSObject, WKNavigationDelegate {
        @ObservedObject private var webViewModel: WebViewModel
        
        private let parent: PrivacyPolicyView
        
        init(_ parent: PrivacyPolicyView, _ webViewModel: WebViewModel) {
            self.parent = parent
            self.webViewModel = webViewModel
        }
        
        func webView(_ webView: WKWebView,
                     didStartProvisionalNavigation navigation: WKNavigation!) {
            webViewModel.isLoading = true
        }
        
        func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
            webViewModel.isLoading = false
        }
        
        func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {
            webViewModel.isLoading = false
        }
    }
}
