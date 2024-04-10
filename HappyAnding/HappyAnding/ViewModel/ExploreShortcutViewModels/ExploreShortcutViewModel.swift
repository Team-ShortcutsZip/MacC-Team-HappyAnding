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
    @Published var isAnnouncementCellShowing = false
    @Published private(set) var numberOfDisplayedCategories = 6
    
    func changeDisplayedCategories() {
        self.isCategoryCellViewFolded.toggle()
        self.numberOfDisplayedCategories = isCategoryCellViewFolded ? 6 : 12
    }
    
    func announcementCellDidTap() {
        self.isAnnouncementCellShowing = true
    }
    
    func fetchShortcuts(by category: Category) -> [Shortcuts] {
        self.shortcutsZipViewModel.shortcutsInCategory[category.index]
    }
    func fetchShortcuts(by sectionType: SectionType) -> [Shortcuts] {
        sectionType.filterShortcuts(from: self.shortcutsZipViewModel)
    }
    
    func fetchAdminCuration() -> [Curation] {
        self.shortcutsZipViewModel.adminCurations
    }
}
