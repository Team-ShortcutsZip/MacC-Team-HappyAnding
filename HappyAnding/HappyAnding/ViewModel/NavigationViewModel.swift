//
//  NavigationViewModel.swift
//  HappyAnding
//
//  Created by kimjimin on 2022/11/11.
//

import SwiftUI

class ShortcutNavigation: ObservableObject {
    @Published var navigationPath: NavigationPath
    
    init() {
        self.navigationPath = NavigationPath()
    }
}


class CurationNavigation: ObservableObject {
    @Published var navigationPath: NavigationPath
    
    init() {
        self.navigationPath = NavigationPath()
    }
}

class ProfileNavigation: ObservableObject {
    @Published var navigationPath: NavigationPath
    
    init() {
        self.navigationPath = NavigationPath()
    }
}

class WriteShortcutNavigation: ObservableObject {
    @Published var navigationPath: NavigationPath
    
    init() {
        self.navigationPath = NavigationPath()
    }
}

class WriteCurationNavigation: ObservableObject {
    @Published var navigationPath: NavigationPath
    
    init() {
        self.navigationPath = NavigationPath()
    }
}
