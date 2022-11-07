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
    
    var url: String
    
    init(url: String) {
        self.url = url 
    }
}


struct PrivacyPolicyView: UIViewRepresentable {
    
    @ObservedObject var webViewModel: WebViewModel
    
    let webView = WKWebView()
    
    func makeCoordinator() -> PrivacyPolicyView.Coordinator {
        Coordinator(self, webViewModel)
    }
    
    func makeUIView(context: Context) -> WKWebView {
        
        if let url = URL(string: self.webViewModel.url) {
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
