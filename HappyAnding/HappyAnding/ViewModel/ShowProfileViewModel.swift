//
//  ShowProfileViewModel.swift
//  HappyAnding
//
//  Created by kimjimin on 2023/07/08.
//

import SwiftUI

final class ShowProfileViewModel: ObservableObject {
    
    private let shortcutsZipViewModel = ShortcutsZipViewModel.share
    
    @Published var user: User
    @Published private(set) var shortcuts: [Shortcuts] = []
    @Published private(set) var curations: [Curation] = []
    @Published private(set) var userGrade = Image(systemName: "person.crop.circle.fill")
    @Published var currentTab: Int = 0
    @Published private(set) var animationAmount = 0.0
        
    init(data: User) {
        self.user = data
        self.userGrade = shortcutsZipViewModel.fetchShortcutGradeImage(isBig: true, shortcutGrade: shortcutsZipViewModel.checkShortcutGrade(userID: data.id))
        self.shortcuts = shortcutsZipViewModel.allShortcuts.filter { $0.author == data.id }
        self.curations = shortcutsZipViewModel.fetchCurationByAuthor(author: data.id)
    }
    
    func profileDidTap() {
        self.animationAmount += 360
    }
    
    func moveTab(to tab: Int) {
        self.currentTab = tab
    }
}
