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
        db.collection("Shortcut").getDocuments() { (querySnapshot, error) in
            if let error {
                print("Error getting documents: \(error)")
            } else {
                for document in querySnapshot!.documents {
                    print("\(document.documentID) => \(document.data())")
                }
            }
        }
    }
    
    func createShortcut(shortcut: Shortcuts) {
        db.collection("Shortcut").document(shortcut.id).setData(shortcut.dictionary) { error in
            if let error {
                print("Error writing document: \(error)")
            } else {
                print("Document successfully written!")
            }
        }
    }
    
    func deleteShortcut(shortcut: Shortcuts) {
        db.collection("Shortcut").document(shortcut.id).delete() { error in
            if let error {
                print("Error removing document: \(error)")
            } else {
                print("Document successfully removed")
            }
        }
    }
}
