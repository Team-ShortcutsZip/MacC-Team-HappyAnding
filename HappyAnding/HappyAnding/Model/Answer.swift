//
//  Answer.swift
//  HappyAnding
//
//  Created by 임정욱 on 4/4/24.
//

import Foundation

struct Answer: Identifiable, Codable, Equatable, Hashable {
    var id = UUID().uuidString
    var body: String = ""
    var postedBy: String = ""
    var postedAt:[String] = [Date().getDate()]
    var images: [String] = []
    var likesCount: Int = 0
    var isAccepted: Bool = false
    var comments: [String] = []
    
    var dictionary: [String: Any] {
        let data = (try? JSONEncoder().encode(self)) ?? Data()
        return (try? JSONSerialization.jsonObject(with: data, options: .mutableContainers) as? [String: Any]) ?? [:]
    }
    
    init(body: String, postedBy: String, images: [String] = [], likesCount: Int = 0, isAccepted: Bool = false, comments: [String] = []) {
        self.body = body
        self.postedBy = postedBy
        self.images = images
        self.likesCount = likesCount
        self.isAccepted = isAccepted
        self.comments = comments
    }
}
