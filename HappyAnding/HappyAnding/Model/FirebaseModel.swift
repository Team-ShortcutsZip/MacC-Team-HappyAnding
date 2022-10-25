//
//  FirebaseModel.swift
//  HappyAnding
//
//  Created by 이지원 on 2022/10/25.
//

import Foundation

// TODO: Shortcuts -> Shortcut으로 이름 변경 필요

struct Shortcuts: Identifiable, Codable {
    var id = UUID().uuidString
    var sfSymbol: String
    var color: String
    var title: String
    var subtitle: String
    var description: String
    var category: [String]
    var requiredApp: [String]
    var date: Date
    var numberOfLike: Int
    var numberOfDownload: Int
    var author: String
    var downloadLink: [String]
    
    var dictionary: [String: Any] {
        let data = (try? JSONEncoder().encode(self)) ?? Data()
        return (try? JSONSerialization.jsonObject(with: data, options: .mutableContainers) as? [String: Any]) ?? [:]
    }
}
