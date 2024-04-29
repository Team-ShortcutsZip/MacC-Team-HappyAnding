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
    
    func fetchTitleImage() -> some View {
        switch self {
        case .recent:
            return Image("new")
                .resizable()
                .scaledToFit()
                .frame(width: 19)
                .foregroundStyle(
                    Color(hexString: "E4C139"),
                    Color(hexString: "E4C139")
                )
                .shadow(color: Color(hexString: "E5C239").opacity(0.36),
                            radius: 8,
                            x: 0,
                            y: 0)
        case .download:
            return Image("ranked")
                .resizable()
                .scaledToFit()
                .frame(width: 19)
                .foregroundStyle(
                    SCZColor.CharcoalGray.opacity48,
                    SCZColor.CharcoalGray.opacity48
                )
                .shadow(color: Color.black.opacity(0.16),
                            radius: 8,
                            x: 0,
                            y: 0)
        case .popular:
            return Image("loved")
                .resizable()
                .scaledToFit()
                .frame(width: 19)
                .foregroundStyle(
                    SCZColor.SCZBlue.opacity88,
                    SCZColor.SCZBlue.opacity88
                )
                .shadow(color: SCZColor.SCZBlue.opacity48,
                            radius: 8,
                            x: 0,
                            y: 0)
        case .myShortcut:
            return Image(systemName: "square.text.square.fill")
                .resizable()
                .scaledToFit()
                .frame(width: 19)
                .foregroundStyle(
                    SCZColor.CharcoalGray.opacity64,
                    Color.white
                )
                .shadow(color: Color.clear,
                            radius: 0,
                            x: 0,
                            y: 0)
        case .myDownloadShortcut:
            return Image(systemName: "arrow.down.square.fill")
                .resizable()
                .scaledToFit()
                .frame(width: 19)
                .foregroundStyle(
                    Color.white,
                    SCZColor.CharcoalGray.opacity24
                )
                .shadow(color: Color.clear,
                            radius: 0,
                            x: 0,
                            y: 0)
        case .myLovingShortcut:
            return Image("loved")
                .resizable()
                .scaledToFit()
                .frame(width: 19)
                .foregroundStyle(
                    SCZColor.SCZBlue.opacity88,
                    SCZColor.SCZBlue.opacity88
                )
                .shadow(color: Color.black.opacity(0.16),
                            radius: 8,
                            x: 0,
                            y: 0)
        }
    }
}
