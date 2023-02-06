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

struct PrivacyPolicyView: View {
    
    @ObservedObject var viewModel: WebViewModel
    
    @Binding var isTappedPrivacyButton: Bool
    
    let url: String
    
    var body: some View {
        
        VStack {
            HStack(spacing: 0) {
                
                Button {
                    self.isTappedPrivacyButton = false
                } label: {
                    Text(TextLiteral.close)
                        .foregroundColor(.Gray5)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(.leading, 16)
                }
                
                Text(TextLiteral.settingViewPrivacyPolicy)
                    .Headline()
                    .frame(maxWidth: .infinity)
                
                Spacer()
                    .frame(maxWidth: .infinity)
            }
            .padding(.top, 24)
            
            PrivacyPolicyContentView(webViewModel: viewModel, url: self.url)
        }
    }
}

struct PrivacyPolicyContentView: UIViewRepresentable {
    
    @ObservedObject var webViewModel: WebViewModel
    
    let url: String
    let webView = WKWebView()
    
    func makeCoordinator() -> PrivacyPolicyContentView.Coordinator {
        Coordinator(self, webViewModel)
    }
    
    func makeUIView(context: Context) -> WKWebView {
        
        if let url = URL(string: self.url) {
            webView.navigationDelegate = context.coordinator
            self.webView.load(URLRequest(url: url))
        }
        return webView
    }
    
    func updateUIView(_ uiView: WKWebView,
                      context: UIViewRepresentableContext<PrivacyPolicyContentView>) {
        return
    }
}

extension PrivacyPolicyContentView {
    
    class Coordinator: NSObject, WKNavigationDelegate {
        
        @ObservedObject private var webViewModel: WebViewModel
        
        private let parent: PrivacyPolicyContentView
        
        init(_ parent: PrivacyPolicyContentView, _ webViewModel: WebViewModel) {
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
