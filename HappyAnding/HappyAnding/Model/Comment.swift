//
//  Comment.swift
//  HappyAnding
//
//  Created by 전지민 on 2022/11/18.
//

import Foundation

struct Comments: Identifiable, Codable {
    var id: String     //댓글이 달린 단축어 id
    var comments: [Comment]
    
    var dictionary: [String: Any] {
        let data = (try? JSONEncoder().encode(self)) ?? Data()
        return (try? JSONSerialization.jsonObject(with: data, options: .mutableContainers) as? [String: Any]) ?? [:]
    }
}

struct Comment: Identifiable, Codable, Hashable {
    var id = UUID().uuidString
    var bundel_id = "\(Date().getDate())_\(UUID().uuidString)"       //원댓글과 대댓글을 묶는 id
    var user_id: String         //작성자 uid
    var date: String            //처음 작성한 날짜만 저장
    var depth: Int              //0이면 원댓글, 1이면 대댓글
    var contents: String
}

extension Comments {
    func fetchSortedComment() -> [Comment] {
        let sortedComments = self.comments.sorted(by: { lhs, rhs in
            if lhs.bundel_id == rhs.bundel_id {
                if lhs.depth < rhs.depth {
                    return true
                }
            } else if lhs.bundel_id < rhs.bundel_id {
                return true
            }
            return false
        })
        return sortedComments
    }
}
