//
//  SectionType.swift
//  HappyAnding
//
//  Created by 이지원 on 2022/10/22.
//

import Foundation

enum SectionType {
    case recent
    case download
    case popular
    case myShortcut
    case myLovingShortcut
    case myDownloadShortcut
    
    var title: String {
        switch self {
        case .recent:
            return TextLiteral.recentRegisteredViewTitle
        case .download:
            return TextLiteral.downloadRankViewTitle
        case .popular:
            return TextLiteral.lovedShortcutViewTitle
        case .myShortcut:
            return TextLiteral.myShortcutCardListViewTitle
        case .myLovingShortcut:
            return TextLiteral.myPageViewLikedShortcuts
        case .myDownloadShortcut:
            return TextLiteral.myPageViewDownloadedShortcuts
        }
    }
    
    func filterShortcuts(from viewModel: ShortcutsZipViewModel) -> [Shortcuts] {
        switch self {
        case .recent:
            return viewModel.allShortcuts
        case .download:
            return viewModel.sortedShortcutsByDownload
        case .myShortcut:
            return viewModel.shortcutsMadeByUser
        case .popular:
            return viewModel.sortedShortcutsByLike
        case .myLovingShortcut:
            return viewModel.shortcutsUserLiked
        case .myDownloadShortcut:
            return viewModel.shortcutsUserDownloaded
        }
    }
}
