//
//  SectionType.swift
//  HappyAnding
//
//  Created by 이지원 on 2022/10/22.
//

import Foundation
import SwiftUI

enum SectionType {
    case recent
    case download
    case popular
    case myShortcut
    case myLovingShortcut
    case myDownloadShortcut
    
    var icon: String {
        switch self {
        case .recent:
            return "sparkles"
        case .download:
            return "trophy.fill"
        case .popular:
            return "heart.fill"
        case .myShortcut:
            return "square.text.square"
        case .myLovingShortcut:
            return "heart.fill"
        case .myDownloadShortcut:
            return "arrow.down.square.fill"
        }
    }
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
    
    func fetchTitleIcon() -> some View {
        switch self {
        case .recent:
            return Image(systemName: self.icon)
                .foregroundStyle(
                    Color(hexString: "E4C139"),
                    Color(hexString: "E4C139")
                )
        case .download:
            return Image(systemName: self.icon)
                .foregroundStyle(
                    Color(hexString: "404040", opacity: 0.48),
                    Color(hexString: "404040", opacity: 0.48)
                )
        case .popular:
            return Image(systemName: self.icon)
                .foregroundStyle(
                    Color(hexString: "3366FF", opacity: 0.88),
                    Color(hexString: "3366FF", opacity: 0.88)
                )
        case .myShortcut:
            return Image(systemName: "square.text.square.fill")
                .foregroundStyle(
                    SCZColor.CharcoalGray.opacity64,
                    Color.white
                )
        case .myDownloadShortcut:
            return Image(systemName: "arrow.down.square.fill")
                .foregroundStyle(
                    Color.white,
                    SCZColor.CharcoalGray.opacity24
                )
        case .myLovingShortcut:
            return Image(systemName: "heart.fill")
                .foregroundStyle(
                    Color(hexString: "3366FF", opacity: 0.88),
                    Color(hexString: "3366FF", opacity: 0.88)
                )
        }
    }
}
