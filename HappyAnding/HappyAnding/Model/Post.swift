//
//  Post.swift
//  HappyAnding
//
//  Created by 임정욱 on 4/4/24.
//

import Foundation

struct Post: Identifiable, Codable, Equatable, Hashable {
    
    let id : String
    let type: PostType
    let createdAt: String
    let author: String
    
    var content: String
    var shortcuts: [String]
    var images: [String]
    var likedBy: [String:Bool]
    var likeCount: Int
    var commentCount: Int
    
    init(type: PostType, content: String, author: String, shortcuts: [String] = [], images: [String] = []) {
        
        self.id = UUID().uuidString
        self.createdAt = Date().getDate()
        
        self.type = type
        self.content = content
        self.author = author
        self.shortcuts = shortcuts
        self.images = images
        
        self.likeCount = 0
        self.commentCount = 0
        self.likedBy = [:]
        
    }
    
    var dictionary: [String: Any] {
        let data = (try? JSONEncoder().encode(self)) ?? Data()
        return (try? JSONSerialization.jsonObject(with: data, options: .mutableContainers) as? [String: Any]) ?? [:]
    }
}
