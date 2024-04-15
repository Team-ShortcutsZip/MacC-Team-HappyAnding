//
//  MyPageViewModel.swift
//  HappyAnding
//
//  Created by JeonJimin on 4/15/24.
//

import Foundation
import Combine

final class MyPageViewModel: ObservableObject {
    private let shortcutsZipViewModel = ShortcutsZipViewModel.share
    private var cancellables = Set<AnyCancellable>()
    
    @Published var myShortcuts: [Shortcuts] = []
    @Published var myDownloadShortcuts: [Shortcuts] = []
    @Published var myLovingShortcuts: [Shortcuts] = []
    
    @Published var isMyDownloadShortcutFolded = false {
        didSet {
            UserDefaults.standard.set(isMyDownloadShortcutFolded, forKey: "isMyDownloadShortcutFolded")
        }
    }
    @Published var isMyLovingShortcutFolded = false {
        didSet {
            UserDefaults.standard.set(isMyLovingShortcutFolded, forKey: "isMyLovingShortcutFolded")
        }
    }
    
    init() {
        shortcutsZipViewModel.$shortcutsMadeByUser
            .sink { [weak self] in self?.myShortcuts = $0 }
            .store(in: &cancellables)
        
        shortcutsZipViewModel.$shortcutsUserDownloaded
            .sink { [weak self] in self?.myDownloadShortcuts = $0 }
            .store(in: &cancellables)
        
        shortcutsZipViewModel.$shortcutsUserLiked
            .sink { [weak self] in self?.myLovingShortcuts = $0 }
            .store(in: &cancellables)
        
        self.isMyDownloadShortcutFolded = UserDefaults.standard.bool(forKey: "isMyDownloadShortcutFolded")
        self.isMyLovingShortcutFolded = UserDefaults.standard.bool(forKey: "isMyLovingShortcutFolded")
    }
    
    func fetchUserInfo() -> String {
        shortcutsZipViewModel.userInfo?.nickname ?? TextLiteral.defaultUser
    }
}
