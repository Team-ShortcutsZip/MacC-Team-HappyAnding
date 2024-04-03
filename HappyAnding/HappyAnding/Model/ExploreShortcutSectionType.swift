//
//  ExploreShortcutSectionType.swift
//  HappyAnding
//
//  Created by JeonJimin on 4/2/24.
//

import SwiftUI

enum ExploreShortcutSectionType: String {
    case new = "sparkles"
    case mostDownloaded = "trophy.fill"
    case mostLoved = "heart.fill"
    
    func getTitleImage() -> some View {
        switch self {
        case .new:
            return Image(systemName: self.rawValue)
                .foregroundStyle(
                    Color(hexString: "E4C139")
                )
                
        case .mostDownloaded:
            return Image(systemName: self.rawValue)
                .foregroundStyle(
                    Color(hexString: "404040", opacity: 0.48)
                )
        case .mostLoved:
            return Image(systemName: self.rawValue)
                .foregroundStyle(
                    Color(hexString: "3366FF", opacity: 0.88)
                )
        }
    }
    func getTitleView() -> some View {
        switch self {
        case .new:
            return HStack {
                Image(systemName: self.rawValue)
                    .foregroundStyle(
                        Color(hexString: "E4C139")
                    )
                Text(TextLiteral.newShortcutsTitle)
                    .foregroundStyle(SCZColor.Basic)
            }
                
        case .mostDownloaded:
            return HStack {
                Image(systemName: self.rawValue)
                    .foregroundStyle(
                        Color(hexString: "404040", opacity: 0.48)
                    )
                Text(TextLiteral.downloadRankViewTitle)
                    .foregroundStyle(SCZColor.Basic)
            }
        case .mostLoved:
            return HStack {
                Image(systemName: self.rawValue)
                    .foregroundStyle(
                        Color(hexString: "3366FF", opacity: 0.88)
                    )
                Text(TextLiteral.lovedShortcutViewTitle)
                    .foregroundStyle(SCZColor.Basic)
            }
        }
    }
    
    func filterShortcuts(from viewModel: ShortcutsZipViewModel) -> [Shortcuts] {
        switch self {
        case .new:
            return viewModel.allShortcuts
        case .mostDownloaded:
            return viewModel.sortedShortcutsByDownload
        case .mostLoved:
            return viewModel.sortedShortcutsByLike
        }
    }
}
