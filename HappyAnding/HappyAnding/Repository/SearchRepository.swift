//
//  SearchRepository.swift
//  HappyAnding
//
//  Created by 임정욱 on 5/2/24.
//

import Foundation
import FirebaseCore
import FirebaseFirestore


class SearchRepository {
    
    
    private let db = Firestore.firestore()
    private let postCollection: String = "Post"
    private let shortcutCollection: String = "Shortcut"
    
    
    
    public func searchContentAndShortcuts(keyword: String, completion: @escaping ([[Any]]) -> Void) {
        let db = Firestore.firestore()
        let postsRef = db.collection(postCollection)
        let shortcutsRef = db.collection(shortcutCollection)
        
        let group = DispatchGroup()
        var postsResults = [Post]()
        var shortcutsResults = [Shortcuts]()
        var errors: [Error] = []

        let searchFieldsShortcuts = ["title", "subtitle", "description"]
        for field in searchFieldsShortcuts {
            group.enter()
            shortcutsRef.whereField(field, arrayContains: keyword).getDocuments { (snapshot, error) in
                defer { group.leave() }
                if let snapshot = snapshot {
                    shortcutsResults += snapshot.documents.compactMap { document -> Shortcuts? in
                        try? document.data(as: Shortcuts.self)
                    }
                } else if let error = error {
                    errors.append(error)
                }
            }
        }

        let searchFieldsPosts = ["title", "content"]
        for field in searchFieldsPosts {
            group.enter()
            postsRef.whereField(field, arrayContains: keyword).getDocuments { (snapshot, error) in
                defer { group.leave() }
                if let snapshot = snapshot {
                    postsResults += snapshot.documents.compactMap { document -> Post? in
                        try? document.data(as: Post.self)
                    }
                } else if let error = error {
                    errors.append(error)
                }
            }
        }

        group.notify(queue: .main) {
            if errors.isEmpty {
                let combinedResults = [shortcutsResults as [Any], postsResults as [Any]]
                completion(combinedResults)
            } else {
                completion([])
            }
        }
    }
    
    
  
}
