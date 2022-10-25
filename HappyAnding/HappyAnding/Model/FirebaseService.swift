//
//  FirebaseService.swift
//  HappyAnding
//
//  Created by 전지민 on 2022/10/25.
//

import Foundation
import FirebaseCore
import FirebaseFirestore
import FirebaseAuth

class FirebaseService {
    private let db = Firestore.firestore()
    
    func fetchShortcut() {
        db.collection("Shortcut").getDocuments() { (querySnapshot, err) in
            if let err = err {
                print("Error getting documents: \(err)")
            } else {
                for document in querySnapshot!.documents {
                    print("\(document.documentID) => \(document.data())")
                }
            }
        }
    }
    
    func createShortcut(shortcut: Shortcuts) {
        
        let refernece = db.collection("Shortcut")
        do {
            try refernece.addDocument(data: shortcut.dictionary)
            print("stored with new docuent reference")
        } catch {
            print(error.localizedDescription)
        }
    }
}
