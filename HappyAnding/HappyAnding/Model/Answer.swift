//
//  Answer.swift
//  HappyAnding
//
//  Created by 임정욱 on 4/4/24.
//

import Foundation

struct Answer: Identifiable, Codable, Equatable, Hashable {
    
    let id: String
    let postId : String
    let createdAt: String
    let author: String
    
    var content: String
    var isAccepted: Bool
    var images: [String]
    var likedBy: [String:Bool]
    var likeCount: Int
    
    init(content: String, author: String, postId:String, images: [String] = []) {
        
        self.id = UUID().uuidString
        self.createdAt = Date().getDate()
        
        self.content = content
        self.isAccepted = false
        self.author = author
        self.postId = postId
        self.images = images
        
        self.likeCount = 0
        self.likedBy = [:]
    }
    
    var dictionary: [String: Any] {
        let data = (try? JSONEncoder().encode(self)) ?? Data()
        return (try? JSONSerialization.jsonObject(with: data, options: .mutableContainers) as? [String: Any]) ?? [:]
    }
}
