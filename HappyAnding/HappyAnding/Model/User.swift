//
//  User.swift
//  HappyAnding
//
//  Created by 이지원 on 2022/10/25.
//

import Foundation

struct User: Identifiable, Codable, Hashable {
    var id: String
    var nickname: String
    var likedShortcuts: [String]
    var downloadedShortcuts: [DownloadedShortcut]
    
    var dictionary: [String: Any] {
        let data = (try? JSONEncoder().encode(self)) ?? Data()
        return (try? JSONSerialization.jsonObject(with: data, options: .mutableContainers) as? [String: Any]) ?? [:]
    }
}

struct DownloadedShortcut: Identifiable, Codable, Hashable {
    var id: String
    var downloadLink: String
}
