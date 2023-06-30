//
//  ListShortcutViewModel.swift
//  HappyAnding
//
//  Created by kimjimin on 2023/06/30.
//

import SwiftUI

final class ListShortcutViewModel: ObservableObject {
    
    var shortcutsZipViewModel = ShortcutsZipViewModel.share
    
    @Published private(set) var shortcuts: [Shortcuts] = []
    @Published private(set) var sectionType: SectionType = .download
    
    
    init(data: SectionType) {
        sectionType = data
        shortcuts = fetchShortcutsBySectionType()
    }
    
    func fetchShortcutsBySectionType() -> [Shortcuts] {
        switch self.sectionType {
        case .recent: return shortcutsZipViewModel.allShortcuts
        case .download: return shortcutsZipViewModel.sortedShortcutsByDownload
        case .popular: return shortcutsZipViewModel.sortedShortcutsByLike
        case .myDownloadShortcut: return  shortcutsZipViewModel.shortcutsUserDownloaded
        case .myLovingShortcut: return  shortcutsZipViewModel.shortcutsUserLiked
        case .myShortcut: return shortcutsZipViewModel.shortcutsMadeByUser
        }
    }
}
