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

struct NavigationProfile: Identifiable, Hashable {
    var id = UUID().uuidString
    
    var userInfo: User?
}

struct NavigationListCategoryShortcutType: Identifiable, Hashable {
    
    var id = UUID().uuidString
    
    var shortcuts: [Shortcuts]
    var categoryName: Category
    var navigationParentView: NavigationParentView
}

struct WriteCurationInfoType: Identifiable, Hashable {
    
    var id = UUID().uuidString
    
    var curation: Curation
    var deletedShortcutCells: [ShortcutCellModel]
    var isEdit: Bool
}

enum NavigationSearch: Hashable, Equatable {
    case first
}

enum NavigationParentView: Int {
    case shortcuts
    case curations
    case myPage
    case writeShortcut
    case writeCuration
}

enum NavigationSettingView: Hashable, Equatable {
    case first
}

enum NavigationNicknameView: Hashable, Equatable {
    case first
}


enum NavigationLisence: Hashable, Equatable {
    case first
}

enum NavigationWithdrawal: Hashable, Equatable {
    case first
}

enum NavigationCheckVersion: Hashable, Equatable {
    case first
}
