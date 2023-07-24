//
//  ExploreShortcutViewModel.swift
//  HappyAnding
//
//  Created by kimjimin on 2023/06/25.
//

import SwiftUI

final class ExploreShortcutViewModel: ObservableObject {
    
    private let shortcutsZipViewModel = ShortcutsZipViewModel.share
    
    @Published private(set) var isCategoryCellViewFolded = true
    @Published var isTappedAnnouncementCell = false
    @Published private(set) var numberOfDisplayedCategories = 6
    
    func changeNumberOfCategories() {
        isCategoryCellViewFolded.toggle()
        numberOfDisplayedCategories = isCategoryCellViewFolded ? 6 : 12
    }
    
    func isShowingAnnouncement() {
        isTappedAnnouncementCell = true
    }
    
    func fetchShortcuts(by category: Category) -> [Shortcuts] {
        shortcutsZipViewModel.shortcutsInCategory[category.index]
    }
    
    func fetchShortcuts(by sectionType: SectionType) -> [Shortcuts] {
        sectionType.filterShortcuts(from: shortcutsZipViewModel)
    }
}
