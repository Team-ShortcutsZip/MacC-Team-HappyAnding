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
    @Published private(set) var category: Category = .business
    
    init(data: Category) {
        shortcuts = shortcutsZipViewModel.shortcutsInCategory[data.index]
        category = data
    }
    
}