//
//  Post.swift
//  HappyAnding
//
//  Created by 임정욱 on 4/4/24.
//

import Foundation

struct Post: Identifiable, Codable, Equatable, Hashable {
    var id = UUID().uuidString
    var type: String = ""
    var title: String = ""
    var body: String = ""
    var postedBy: String
    var postedAt:[String] = [Date().getDate()]
    var images: [String] = []
    var likesCount: Int = 0
    var commentsCount: Int
    var tags: [String] = []
    var comments: [String] = []
    var answers: [String] = []
    

    var dictionary: [String: Any] {
        let data = (try? JSONEncoder().encode(self)) ?? Data()
        return (try? JSONSerialization.jsonObject(with: data, options: .mutableContainers) as? [String: Any]) ?? [:]
    }
    
    init(type: String, title: String, body: String, postedBy: String, images: [String], likesCount: Int, commentsCount: Int, tags: [String], comments: [String], answers: [String]) {
        self.type = type
        self.title = title
        self.body = body
        self.postedBy = postedBy
        self.images = images
        self.likesCount = likesCount
        self.commentsCount = commentsCount
        self.tags = tags
        self.comments = comments
        self.answers = answers
    }
}
