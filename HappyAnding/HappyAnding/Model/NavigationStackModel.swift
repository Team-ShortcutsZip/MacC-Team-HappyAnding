//
//  NavigationListShortcutType.swift
//  HappyAnding
//
//  Created by 이지원 on 2022/11/12.
//

import SwiftUI

struct NavigationListShortcutType: Identifiable, Hashable {
    var id = UUID().uuidString
    
    var sectionType: SectionType
    var shortcuts: [Shortcuts]?
    let navigationParentView: NavigationParentView
}

struct NavigationReadShortcutType: Identifiable, Hashable {
    var id = UUID().uuidString

    var shortcut: Shortcuts?
    let shortcutID: String
    let navigationParentView: NavigationParentView
}

struct NavigationReadUserCurationType: Identifiable, Hashable {
    var id = UUID().uuidString
    
    var userCuration: Curation
    let navigationParentView: NavigationParentView
}

struct NavigationListCurationType: Identifiable, Hashable {
    var id = UUID().uuidString
    
    var type: CurationType
    var title: String?
    var isAllUser: Bool
    let navigationParentView: NavigationParentView
    var curation: [Curation]
}

enum NavigationParentView: Int {
    case shortcuts
    case curations
    case myPage
    case writeShortcut
    case writeCuration
}
