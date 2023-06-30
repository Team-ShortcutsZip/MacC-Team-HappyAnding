//
//  ListCategoryShortcutViewModel.swift
//  HappyAnding
//
//  Created by kimjimin on 2023/06/30.
//

import SwiftUI

final class ListCategoryShortcutViewModel: ObservableObject {
    
    var shortcutsZipViewModel = ShortcutsZipViewModel.share
    
    @Published private(set) var shortcuts: [Shortcuts] = []
    @Published private(set) var categoryName: Category = .business
    
    init(data: NavigationListCategoryShortcutType) {
        shortcuts = shortcutsZipViewModel.shortcutsInCategory[data.categoryName.index]
        categoryName = data.categoryName
    }
    
}
