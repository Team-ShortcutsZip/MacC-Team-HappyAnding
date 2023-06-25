//
//  WriteCurationViewModel.swift
//  HappyAnding
//
//  Created by JeonJimin on 2023/06/23.
//

import SwiftUI

final class WriteCurationViewModel: ObservableObject, Hashable {
    
    static func == (lhs: WriteCurationViewModel, rhs: WriteCurationViewModel) -> Bool {
        return false
    }
    func hash(into hasher: inout Hasher) {
        hasher.combine(curation)
    }
    
    private var shortcutsZipViewModel = ShortcutsZipViewModel.share
    
    //WriteCurationSet
    @Published var isWriting = false
    @Published var isEdit = false
    
    //좋아요 + 내가 작성한 단축어 목록
    @Published var shortcutCells = [ShortcutCellModel]()
    //모음집 편집 시 전달받는 기존 모음집 정보
    @Published var curation = Curation(title: "", subtitle: "", isAdmin: false, background: "", author: "", shortcuts: [ShortcutCellModel]())
    
    @Published var isTappedQuestionMark = false
    //기존 선택 -> 편집 시 선택 해제 되어 기존 모음집 정보에서 삭제해야할 단축어 배열
    @Published var deletedShortcutCells = [ShortcutCellModel]()
    
    
    //WriteCurationInfo
    @Published var writeCurationNavigation = WriteCurationNavigation()
    @Published var isValidTitle = false
    @Published var isValidDescription = false
    
    var isIncomplete: Bool {
        !(isValidTitle && isValidDescription)
    }
    
    init() {
        
    }
    
    init(data: Curation) {
        self.curation = data
    }
    
    func fetchMakeCuration() {
        shortcutCells = shortcutsZipViewModel.fetchShortcutMakeCuration().sorted { $0.title < $1.title }
        if isEdit {
            deletedShortcutCells = curation.shortcuts
        }
    }
    
    func addCuration() {
        shortcutsZipViewModel.addCuration(curation: curation, isEdit: isEdit, deletedShortcutCells: deletedShortcutCells)
        
        self.isWriting.toggle()
        if #available(iOS 16.1, *) {
            writeCurationNavigation.navigationPath = .init()
        }
    }
}
