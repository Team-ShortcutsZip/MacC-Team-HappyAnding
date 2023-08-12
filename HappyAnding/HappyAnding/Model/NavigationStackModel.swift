//
//  NavigationListShortcutType.swift
//  HappyAnding
//
//  Created by 이지원 on 2022/11/12.
//

import SwiftUI

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
