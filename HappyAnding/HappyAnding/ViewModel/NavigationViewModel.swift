//
//  NavigationViewModel.swift
//  HappyAnding
//
//  Created by kimjimin on 2022/11/11.
//

import SwiftUI

class NavigationModel: ObservableObject {
    @Published var shortcutPath: NavigationPath
    @Published var curationPath: NavigationPath
    @Published var profilePath: NavigationPath
    
    init() {
        self.shortcutPath = NavigationPath()
        self.curationPath = NavigationPath()
        self.profilePath = NavigationPath()
    }
}
