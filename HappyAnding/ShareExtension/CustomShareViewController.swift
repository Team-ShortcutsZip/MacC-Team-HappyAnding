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
    
    var shortcut = Shortcuts(sfSymbol: "", color: "", title: "", subtitle: "", description: "", category: [], requiredApp: [], numberOfLike: 0, numberOfDownload: 0, author: "", shortcutRequirements: "", downloadLink: [], curationIDs: [])
    let shareExtensionViewModel = ShareExtensionViewModel()
    
    ///viewdidload
    override func viewDidLoad() {
        super.viewDidLoad()
        pasteUrl { url in
            self.shareExtensionViewModel.shortcut.downloadLink.append("\(url)")
            let extShortcutsView = UIHostingController(rootView: ShareExtensionWriteShortcutTitleView(shareExtensionViewModel: self.shareExtensionViewModel))
            
            self.view.addSubview(extShortcutsView.view)
            
            extShortcutsView.view.translatesAutoresizingMaskIntoConstraints = false
            extShortcutsView.view.topAnchor.constraint(equalTo: self.view.topAnchor).isActive = true
            extShortcutsView.view.bottomAnchor.constraint(equalTo: self.view.bottomAnchor).isActive = true
            extShortcutsView.view.leftAnchor.constraint(equalTo: self.view.leftAnchor).isActive = true
            extShortcutsView.view.rightAnchor.constraint(equalTo: self.view.rightAnchor).isActive = true
        }
        setupNavBar()
        self.view.backgroundColor = UIColor(Color.Background)
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
    
    func pasteUrl(completionHandler: @escaping ((NSSecureCoding)->())) {
        let extensionItems = extensionContext?.inputItems as! [NSExtensionItem]
        for extensionItem in extensionItems {
            if let itemProviders = extensionItem.attachments {
                for itemProvider in itemProviders {
                    if itemProvider.hasItemConformingToTypeIdentifier(UTType.url.identifier) {
                        itemProvider.loadItem(forTypeIdentifier: UTType.url.identifier, options: nil, completionHandler: { result, error in
                            DispatchQueue.main.async {
                                if let urlStr = result {
                                    completionHandler(urlStr)
                                }
                            }
                        })
                    }
                }
            }
        }
    }
}

