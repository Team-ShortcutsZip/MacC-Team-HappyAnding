//
//  CustomShareViewController.swift
//  ShareExtension
//
//  Created by HanGyeongjun on 2022/11/19.
//

import UIKit
import SwiftUI
//import Social
import MobileCoreServices
import UniformTypeIdentifiers

import FirebaseCore


class CustomShareViewController: UIViewController {
    
    @State var isWriting = false
//    @State var hostAppShortcutLink: String = "test"
    
    func urlData() {
        let extensionItems = extensionContext?.inputItems as! [NSExtensionItem]
              
              for extensionItem in extensionItems {
                  if let itemProviders = extensionItem.attachments {
                      for itemProvider in itemProviders {
                          // 해당 객체가 있는지 식별
//                          if itemProvider.hasItemConformingToTypeIdentifier(kUTTypeImage as String) {
//                              itemProvider.loadItem(forTypeIdentifier: kUTTypeImage as String, options: nil, completionHandler: { result, error in
////                                  var image: UIImage?
////                                  if result is UIImage {
////                                      image = result as? UIImage
////                                  }
//
//                                  if result is URL {
//                                      let data = try? Data(contentsOf: result as! URL)
////                                      image = UIImage(data: data!)!
//                                  }
//
////                                  if result is Data {
////                                      image = UIImage(data: result as! Data)!
////                                  }
//                              })
//                          }
                          
                          if itemProvider.hasItemConformingToTypeIdentifier(kUTTypeURL as String) {
                              itemProvider.loadItem(forTypeIdentifier: kUTTypeURL as String, options: nil, completionHandler: { result, error in
                                  let data = NSData.init(contentsOf:result as! URL)
                                  DispatchQueue.main.async {
                                      if let urlStr = result {
//                                          self.hostAppShortcutLink = "\(urlStr)"
                                          self.setupViews(link: "\(urlStr)")
                                      }
                                  }
                              })
                          }
                      }
                  }
              }
    }
    
    override func viewDidLoad() {
        urlData()
        setupNavBar()
        super.viewDidLoad()
//                setupViews()
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
    
    
    ///UIHostingView (SwiftUI view)
//    private lazy var extShortcutsView: UIView = {
//        let extShortcutsView = UIHostingController(rootView: ShareExtensionWriteShortcutTitleView(isWriting: self.$isWriting, shareExtensionLink: hostAppShortcutLink, isEdit: false))
//        self.present(extShortcutsView, animated: true)
//        return UIView()
//    }()
    private func setupViews(link: String) {
        let extShortcutsView = UIHostingController(rootView: ShareExtensionWriteShortcutTitleView(isWriting: self.$isWriting, shareExtensionLink: link, isEdit: false))
        self.present(extShortcutsView, animated: true)
//        self.view.addSubview(extShortcutsView)
//        NSLayoutConstraint.activate([
//            extShortcutsView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
//            extShortcutsView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor),
//            extShortcutsView.centerYAnchor.constraint(equalTo: self.view.centerYAnchor),
//            extShortcutsView.heightAnchor.constraint(equalToConstant: 44)
//        ])
    }
}

