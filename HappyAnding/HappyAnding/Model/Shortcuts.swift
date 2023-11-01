//
//  FirebaseModel.swift
//  HappyAnding
//
//  Created by 이지원 on 2022/10/25.
//

import Foundation

// TODO: Shortcuts -> Shortcut으로 이름 변경 필요

struct Shortcuts: Identifiable, Codable, Equatable, Hashable {
    var id = UUID().uuidString
    var sfSymbol: String
    var color: String
    var title: String
    var subtitle: String
    var description: String
    var category: [String]
    var requiredApp: [String]
    var date: [String] = [Date().getDate()]
    var numberOfLike: Int
    var numberOfDownload: Int
    var author: String
    var shortcutRequirements: String
    var downloadLink: [String]
    var curationIDs: [String]
    var updateDescription: [String] = [""]
    
    var dictionary: [String: Any] {
        let data = (try? JSONEncoder().encode(self)) ?? Data()
        return (try? JSONSerialization.jsonObject(with: data, options: .mutableContainers) as? [String: Any]) ?? [:]
    }
    
    init() {
        self.sfSymbol = ""
        self.color = ""
        self.title = ""
        self.subtitle = ""
        self.description = ""
        self.category = []
        self.requiredApp = []
        self.numberOfLike = 0
        self.numberOfDownload = 0
        self.author = ""
        self.shortcutRequirements = ""
        self.downloadLink = []
        self.curationIDs = []
    }
    
    init(sfSymbol: String, color: String, title: String, subtitle: String, description: String, category: [String], requiredApp: [String], numberOfLike: Int, numberOfDownload: Int, author: String, shortcutRequirements: String, downloadLink: [String], curationIDs: [String]) {
        self.sfSymbol = sfSymbol
        self.color = color
        self.title = title
        self.subtitle = subtitle
        self.description = description
        self.category = category
        self.requiredApp = requiredApp
        self.numberOfLike = numberOfLike
        self.numberOfDownload = numberOfDownload
        self.author = author
        self.shortcutRequirements = shortcutRequirements
        self.downloadLink = downloadLink
        self.curationIDs = curationIDs
    }
}
