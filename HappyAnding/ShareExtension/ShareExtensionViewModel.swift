//
//  ShareExtensionViewModel.swift
//  ShareExtension
//
//  Created by 전지민 on 2022/12/02.
//

import Foundation

import FirebaseCore
import FirebaseFirestore

class ShareExtensionViewModel: ObservableObject {
    private let db = Firestore.firestore()
    
    private var userInfo = UserDefaults.shared.string(forKey: "ShareUserInfo")!
    
    @Published var shortcut = Shortcuts(sfSymbol: "", color: "", title: "", subtitle: "", description: "", category: [], requiredApp: [], numberOfLike: 0, numberOfDownload: 0, author: "", shortcutRequirements: "", downloadLink: [], curationIDs: [])
    
    func setData() {
        self.shortcut.author = userInfo
        db.collection("Shortcut")
            .document(self.shortcut.id)
            .setData(self.shortcut.dictionary) { err in
                if let err = err {
                    print("Error writing document: \(err)")
                } else {
                    print("Document successfully written!")
                }
            }
    }
    
    func isDoneValid() -> Bool {
        !shortcut.color.isEmpty &&
        !shortcut.sfSymbol.isEmpty &&
        !shortcut.title.isEmpty &&
        !shortcut.downloadLink.isEmpty &&
        !shortcut.subtitle.isEmpty &&
        !shortcut.description.isEmpty &&
        !shortcut.category.isEmpty
    }
    
    func isLinkValid(content: String) -> Bool {
        content.hasPrefix("https://www.icloud.com/shortcuts/")
    }
}
