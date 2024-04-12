//
//  CommunityComment.swift
//  HappyAnding
//
//  Created by 임정욱 on 4/4/24.
//

import Foundation


struct CommunityComment: Identifiable, Codable, Equatable, Hashable {
    
    let id: String
    let createdAt: String
    let postId: String
    let author: String
    let parent: String?
    
    var content: String
    var likeCount: Int
    var likedBy: [String:Bool]
    var isAccepted: Bool

    init(content: String, author: String,postId : String, parent: String? = nil) {
        
        self.id = UUID().uuidString
        self.createdAt = Date().getDate()
        
        self.content = content
        self.author = author
        self.parent = parent
        self.postId = postId
        
        self.likeCount = 0
        self.likedBy = [:]
        self.isAccepted = false
    }
    
    var dictionary: [String: Any] {
        let data = (try? JSONEncoder().encode(self)) ?? Data()
        return (try? JSONSerialization.jsonObject(with: data, options: []) as? [String: Any]) ?? [:]
    }
    
}
