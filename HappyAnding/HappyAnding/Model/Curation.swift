//
//  Curation.swift
//  HappyAnding
//
//  Created by 이지원 on 2022/10/25.
//

import Foundation

struct Curation: Identifiable, Equatable, Codable, Hashable {
    
    var id = UUID().uuidString
    var title: String
    var subtitle: String
    var dateTime = Date().getDate()
    var isAdmin: Bool
    var background: String
    var author: String
    var shortcuts: [ShortcutCellModel]
    
    var dictionary: [String: Any] {
        let data = (try? JSONEncoder().encode(self)) ?? Data()
        return (try? JSONSerialization.jsonObject(with: data, options: .mutableContainers) as? [String: Any]) ?? [:]
    }
    
    init(title: String, subtitle: String, isAdmin: Bool, background: String, author: String, shortcuts: [ShortcutCellModel]) {
        self.id = UUID().uuidString
        self.title = title
        self.subtitle = subtitle
        self.dateTime = Date().getDate()
        self.isAdmin = isAdmin
        self.background = background
        self.author = author
        self.shortcuts = shortcuts
    }
    
    init() {
        self.id = UUID().uuidString
        self.title = ""
        self.subtitle = ""
        self.dateTime = Date().getDate()
        self.isAdmin = false
        self.background = ""
        self.author = ""
        self.shortcuts = []
    }
}

struct ShortcutCellModel: Identifiable, Codable, Equatable, Hashable {
    
    var id: String // Shortcut의 UUID
    var sfSymbol: String
    var color: String
    var title: String
    var subtitle: String
    var downloadLink: String
}
