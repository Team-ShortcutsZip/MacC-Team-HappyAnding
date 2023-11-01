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
    
    init() {
        self.id = ""
        self.nickname = ""
        self.likedShortcuts = []
        self.downloadedShortcuts = []
    }
    
    init(id: String, nickname: String, likedShortcuts: [String], downloadedShortcuts: [DownloadedShortcut]) {
        self.id = id
        self.nickname = nickname
        self.likedShortcuts = likedShortcuts
        self.downloadedShortcuts = downloadedShortcuts
    }
}

struct DownloadedShortcut: Identifiable, Codable, Hashable {
    var id: String
    var downloadLink: String
}
