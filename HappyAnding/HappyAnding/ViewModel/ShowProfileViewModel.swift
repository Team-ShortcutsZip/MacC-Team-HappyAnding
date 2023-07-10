//
//  ShowProfileViewModel.swift
//  HappyAnding
//
//  Created by kimjimin on 2023/07/08.
//

import SwiftUI

final class ShowProfileViewModel: ObservableObject {
    
    var shortcutsZipViewModel = ShortcutsZipViewModel.share
    
    @Published var user: User
    @Published private(set) var shortcuts: [Shortcuts] = []
    @Published private(set) var curations: [Curation] = []
    @Published private(set) var userGrade = Image(systemName: "person.crop.circle.fill")
    @Published var currentTab: Int = 0
    @Published var animationAmount = 0.0
        
    init(data: User) {
        self.user = data
        fetchUserGrade()
        fetchShortcuts()
        fetchCurations()
    }

    private func fetchUserGrade() {
        self.userGrade = shortcutsZipViewModel.fetchShortcutGradeImage(isBig: true, shortcutGrade: shortcutsZipViewModel.checkShortcutGrade(userID: user.id))
    }
    
    private func fetchShortcuts() {
        self.shortcuts = shortcutsZipViewModel.allShortcuts.filter { $0.author == user.id }
    }
    
    private func fetchCurations() {
        self.curations = shortcutsZipViewModel.fetchCurationByAuthor(author: user.id)
    }
}
