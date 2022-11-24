//
//  CustomShareViewController.swift
//  ShareExtension
//
//  Created by HanGyeongjun on 2022/11/19.
//

import UIKit
import SwiftUI
import MobileCoreServices
import UniformTypeIdentifiers
import FirebaseCore


class CustomShareViewController: UIViewController {
    
    @State var isWriting = false
    @State var hostAppShortcutLink: String = "test"
    
    func urlData() {

    }
    
    override func viewDidLoad() {
        urlData()
        super.viewDidLoad()
        setupViews()
        self.view.backgroundColor = UIColor(Color.Background)
        setupNavBar()
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
    private lazy var extShortcutsView: UIView = {
        let extShortcutsView = UIHostingController(rootView: ShareExtensionWriteShortcutTitleView(isWriting: self.$isWriting, shareExtensionLink: hostAppShortcutLink, isEdit: false))
        self.present(extShortcutsView, animated: true)
        return UIView()
    }()
    private func setupViews() {
        self.view.addSubview(extShortcutsView)
        NSLayoutConstraint.activate([
            extShortcutsView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
            extShortcutsView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor),
            extShortcutsView.centerYAnchor.constraint(equalTo: self.view.centerYAnchor),
            extShortcutsView.heightAnchor.constraint(equalToConstant: 44)
        ])
    }
}

