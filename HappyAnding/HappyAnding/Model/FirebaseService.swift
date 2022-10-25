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
    private let uid = FirebaseAuth.getuid()
    
    // 병원 이름으로 마음 카드를 가져오는 함수
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
}
