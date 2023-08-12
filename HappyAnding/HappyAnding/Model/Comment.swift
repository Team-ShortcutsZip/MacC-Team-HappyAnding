//
//  Comment.swift
//  HappyAnding
//
//  Created by 전지민 on 2022/11/18.
//

import Foundation

struct Comments: Identifiable, Codable, Equatable {
    var id: String     //댓글이 달린 단축어 id
    var comments: [Comment]
    
    var dictionary: [String: Any] {
        let data = (try? JSONEncoder().encode(self)) ?? Data()
        return (try? JSONSerialization.jsonObject(with: data, options: .mutableContainers) as? [String: Any]) ?? [:]
    }
    
    init() {
        self.id = ""
        self.comments = []
    }
    
    init(id: String, comments: [Comment]) {
        self.id = id
        self.comments = comments
    }
}

struct Comment: Identifiable, Codable, Hashable {
    var id = UUID().uuidString
    var bundle_id = "\(Date().getDate())_\(UUID().uuidString)"       //원댓글과 대댓글을 묶는 id
    var user_nickname: String   //작성자 닉네임
    var user_id: String         //작성자 uid
    var date: String            //처음 작성한 날짜만 저장
    var depth: Int              //0이면 원댓글, 1이면 대댓글
    var contents: String
    
    init() {
        self.user_nickname = ""
        self.user_id = ""
        self.date = ""
        self.depth = 0
        self.contents = ""
    }
    
    init(user_nickname: String, user_id: String, date: String, depth: Int, contents: String) {
        self.user_nickname = user_nickname
        self.user_id = user_id
        self.date = date
        self.depth = depth
        self.contents = contents
    }
}

extension Comments {
    func fetchSortedComment() -> [Comment] {
        let sortedComments = self.comments.sorted(by: { lhs, rhs in
            if lhs.bundle_id == rhs.bundle_id {
                if lhs.depth < rhs.depth {
                    return true
                }
            } else if lhs.bundle_id < rhs.bundle_id {
                return true
            }
            return false
        })
        return sortedComments
    }
}

extension Comment {
    func resetComment() -> Comment {
        Comment(user_nickname: "", user_id: "", date: "", depth: 0, contents: "")
    }
}
