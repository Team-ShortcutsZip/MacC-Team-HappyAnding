//
//  ExploreShortcutViewModel.swift
//  HappyAnding
//
//  Created by kimjimin on 2023/06/25.
//

import SwiftUI

final class ExploreShortcutViewModel: ObservableObject {
    
    var shortcutsZipViewModel = ShortcutsZipViewModel.share
    
    @Published private(set) var isCategoryCellViewFolded = true
    @Published var isTappedAnnouncementCell = false
    @Published private(set) var numberOfDisplayedCategories = 6
    @Published private(set) var randomCategories = Category.allCases.shuffled().prefix(2)
    
    func changeNumberOfCategories() {
        isCategoryCellViewFolded.toggle()
        numberOfDisplayedCategories = isCategoryCellViewFolded ? 6 : 12
    }
    
    func isShowingAnnouncement() {
        isTappedAnnouncementCell = true
    }
    
    func fetchShortcutsByCategories(category: Category) -> [Shortcuts] {
        shortcutsZipViewModel.shortcutsInCategory[category.index]
    }
}
