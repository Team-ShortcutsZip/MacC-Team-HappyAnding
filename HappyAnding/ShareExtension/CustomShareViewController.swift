//
//  CustomShareViewController.swift
//  ShareExtension
//
//  Created by HanGyeongjun on 2022/11/19.
//

import UIKit
import SwiftUI
import Foundation
import FirebaseCore


class CustomShareViewController: UIViewController {
    
    @State var isWriting = false
        
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        // 1: Set the background and call the function to create the navigation bar
        self.view.backgroundColor = UIColor(Color.Background)
        setupNavBar()
    }
    
//    private func openSwiftUIView() {
//        let hostingController = UIHostingController(rootView: WriteShortcutTitleView(isWriting: self.$isWriting, isEdit: false))
//        hostingController.sizingOptions = .preferredContentSize
//        hostingController.modalPresentationStyle = .popover
//        self.present(hostingController, animated: true)
//    }

    // 2: Set the title and the navigation items
    private func setupNavBar() {
        self.navigationItem.title = "ShortcutsZip"

        let itemCancel = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(cancelAction))
        self.navigationItem.setLeftBarButton(itemCancel, animated: false)

        let itemDone = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(doneAction))
        self.navigationItem.setRightBarButton(itemDone, animated: false)
    }

    // 3: Define the actions for the navigation items
    @objc private func cancelAction () {
        let error = NSError(domain: "some.bundle.identifier", code: 0, userInfo: [NSLocalizedDescriptionKey: "An error description"])
        extensionContext?.cancelRequest(withError: error)
    }

    @objc private func doneAction() {
        extensionContext?.completeRequest(returningItems: [], completionHandler: nil)
    }
    
    private lazy var extShortcutsView: UIView = {
        let extShortcutsView = UIHostingController(rootView: WriteShortcutTitleView(isWriting: self.$isWriting, isEdit: false))
//        self.present(extShortcutsView, animated: true)

//        return extShortcutsView.view
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

