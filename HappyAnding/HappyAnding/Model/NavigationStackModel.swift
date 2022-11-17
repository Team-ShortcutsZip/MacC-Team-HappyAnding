//
//  NavigationListShortcutType.swift
//  HappyAnding
//
//  Created by 이지원 on 2022/11/12.
//

import Foundation

struct NavigationListShortcutType: Identifiable, Hashable {
    var id = UUID().uuidString
    
    var sectionType: SectionType
    var shortcuts: [Shortcuts]?
}

struct NavigationCurationType: Identifiable, Hashable {
    var id = UUID().uuidString
    
    var type: CurationType
    var title: String
    var isAllUser: Bool?
    let isAccessCuration: Bool
}

struct NavigationEditShortcutType: Identifiable, Hashable {
    var id = UUID().uuidString
    
    var shortcut: Shortcuts
}

enum NavigationParentView: Int {
    case shortcuts
    case curations
    case myPage
    case editShortcut
    case editCuration
}
