//
//  User.swift
//  HappyAnding
//
//  Created by 이지원 on 2022/10/25.
//

import Foundation

struct User: Identifiable, Codable {
    var id = UUID().uuidString
    var ninkname: String
    var myShortcuts: [Shortcuts]?
    var likeShortcuts: [Shortcuts]?
    var myCuration: [Curation]?
    var downloadedShortcut: [Shortcuts]?
    
    var dictionary: [String: Any] {
        let data = (try? JSONEncoder().encode(self)) ?? Data()
        return (try? JSONSerialization.jsonObject(with: data, options: .mutableContainers) as? [String: Any]) ?? [:]
    }
}
