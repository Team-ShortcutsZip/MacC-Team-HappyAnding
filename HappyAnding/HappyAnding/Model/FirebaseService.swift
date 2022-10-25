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
        db.collection("Shortcut").document(shortcut.id).setData(shortcut.dictionary) { err in
            if let err = err {
                print("Error writing document: \(err)")
            } else {
                print("Document successfully written!")
            }
        }
    }
}
