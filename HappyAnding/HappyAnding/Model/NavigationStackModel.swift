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

// TODO: Navigation Write Description 이슈를 수정하기 위한 시도! (삭제 가능성 존재)
struct NavigationWriteDescriptionType: Identifiable, Hashable, Equatable {
    var id = UUID().uuidString
    
    var shortcut: Shortcuts
    var isWriting: Bool
    var isEdit: Bool
    var navigationParentView: NavigationParentView
    
    func hash(into hasher: inout Hasher) {
        return hasher.combine(id)
    }
    
    static func == (lhs: NavigationWriteDescriptionType, rhs: NavigationWriteDescriptionType) -> Bool {
        return lhs.id == rhs.id
    }
}

enum NavigationParentView: Int {
    case shortcuts
    case curations
    case myPage
    case editShortcut
    case editCuration
}
