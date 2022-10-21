//
//  TabRouter.swift
//  HappyAnding
//
//  Created by KiWoong Hong on 2022/10/21.
//

import SwiftUI

enum Tab: CaseIterable {
    case exploreShortcut
    case collect
    case myPage
    
    var tabName: String {
        switch self {
        case .exploreShortcut : return "단축어"
        case .collect: return "모음"
        case .myPage: return "프로필"
        }
    }
    
    var systemImage: String {
        switch self {
        case .exploreShortcut : return "house.fill"
        case .collect: return "house.fill"
        case .myPage: return "house.fill"
        }
    }
    
    @ViewBuilder
    var view: some View {
        switch self {
        case .exploreShortcut : ExploreShortcutView()
        case .collect: ExploreCurationView()
        case .myPage: MyPageView()
        }
    }
}
