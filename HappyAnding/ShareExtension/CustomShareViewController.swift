//
//  CustomShareViewController.swift
//  ShareExtension
//
//  Created by HanGyeongjun on 2022/11/19.
//

import UIKit
import SwiftUI
import UniformTypeIdentifiers

import FirebaseCore


class CustomShareViewController: UIViewController {
    
    @State var isWriting = false
    
    func pasteUrl() {
        let extensionItems = extensionContext?.inputItems as! [NSExtensionItem]
        for extensionItem in extensionItems {
            if let itemProviders = extensionItem.attachments {
                for itemProvider in itemProviders {
                    if itemProvider.hasItemConformingToTypeIdentifier(UTType.url.identifier) {
                        itemProvider.loadItem(forTypeIdentifier: UTType.url.identifier, options: nil, completionHandler: { result, error in
                            DispatchQueue.main.async {
                                if let urlStr = result {
                                    self.setupViews(link: "\(urlStr)")
                                }
                            }
                        })
                    }
                }
            }
        }
    }
    
    ///Set Navigation Bar
    private func setupNavBar() {
        self.navigationItem.title = "ShortcutsZip"
        
        let itemCancel = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(cancelAction))
        self.navigationItem.setLeftBarButton(itemCancel, animated: false)
        
        let itemDone = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(doneAction))
        self.navigationItem.setRightBarButton(itemDone, animated: false)
    }
    @objc private func cancelAction () {
        let error = NSError(domain: "some.bundle.identifier", code: 0, userInfo: [NSLocalizedDescriptionKey: "An error description"])
        extensionContext?.cancelRequest(withError: error)
    }
    @objc private func doneAction() {
        extensionContext?.completeRequest(returningItems: [], completionHandler: nil)
    }
    
    ///UIHostingView (SwiftUI view)
    private func setupViews(link: String) {
        let extShortcutsView = UIHostingController(rootView: ShareExtensionWriteShortcutTitleView(isWriting: self.$isWriting, shareExtensionLink: link, isEdit: false))
        self.present(extShortcutsView, animated: true)
    }
    
    ///viewdidload
    override func viewDidLoad() {
        pasteUrl()
        setupNavBar()
        super.viewDidLoad()
        self.view.backgroundColor = UIColor(Color.Background)
    }
}

