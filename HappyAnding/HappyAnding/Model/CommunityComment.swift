//
//  CommunityComment.swift
//  HappyAnding
//
//  Created by 임정욱 on 4/4/24.
//

import Foundation


struct CommunityComment: Identifiable, Codable, Equatable, Hashable {
    var id: String = UUID().uuidString
    var body: String
    var author: String
    var postedAt: String = Date().getDate()
    var likesCount: Int = 0
    var isAccepted: Bool = false
    var comments: [String] = []


    var dictionary: [String: Any] {
        let data = (try? JSONEncoder().encode(self)) ?? Data()
        return (try? JSONSerialization.jsonObject(with: data, options: []) as? [String: Any]) ?? [:]
    }
    

    init(body: String, author: String, images: [String] = [], likesCount: Int = 0, isAccepted: Bool = false, comments: [String] = []) {
        self.body = body
        self.author = author
        self.likesCount = likesCount
        self.isAccepted = isAccepted
        self.comments = comments
    }
}
