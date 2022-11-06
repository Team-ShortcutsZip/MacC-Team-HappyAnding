//
//  PrivacyPolicyView.swift
//  HappyAnding
//
//  Created by 이지원 on 2022/11/07.
//

import SwiftUI
import WebKit

struct PrivacyPolicyView: UIViewRepresentable {
    
    let privacyPolicyURL = "https://noble-satellite-574.notion.site/60d8fa2f417c40cca35e9c784f74b7fd"
    
    func makeUIView(context: Context) -> WKWebView {
        
        guard let url = URL(string: self.privacyPolicyURL) else { return WKWebView() }
        
        let webView = WKWebView()
        webView.load(URLRequest(url: url))
        return webView
    }
    
    func updateUIView(_ uiView: WKWebView,
                      context: UIViewRepresentableContext<PrivacyPolicyView>) {
    }
}

struct PrivacyPolicyView_Previews: PreviewProvider {
    static var previews: some View {
        PrivacyPolicyView()
    }
}
