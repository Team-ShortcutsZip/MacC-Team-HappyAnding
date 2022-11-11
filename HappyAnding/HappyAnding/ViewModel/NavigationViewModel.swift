//
//  NavigationViewModel.swift
//  HappyAnding
//
//  Created by kimjimin on 2022/11/11.
//

import SwiftUI

class ShortcutNavigation: ObservableObject {
    @Published var shortcutPath: NavigationPath
    
    init() {
        self.shortcutPath = NavigationPath()
    }
}


class ProfileNavigation: ObservableObject {
    @Published var navigationPath: NavigationPath
    
    init() {
        self.navigationPath = NavigationPath()
    }
}
