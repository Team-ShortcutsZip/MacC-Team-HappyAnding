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
    @Published var isEdit = false
    
    //좋아요 + 내가 작성한 단축어 목록
    @Published var shortcutCells = [ShortcutCellModel]()
    //CheckboxShortcutCell 선택 여부 저장
    @Published var isShortcutsTapped: [Bool] = []
    
    //모음집 편집 시 전달받는 기존 모음집 정보
    @Published var curation = Curation(title: "", subtitle: "", isAdmin: false, background: "", author: "", shortcuts: [ShortcutCellModel]())
    
    //기존 선택 -> 편집 시 선택 해제 되어 기존 모음집 정보에서 삭제해야할 단축어 배열
    @Published var deletedShortcutCells = [ShortcutCellModel]()
    
    
    //WriteCurationInfo
//    @Published var writeCurationNavigation = WriteCurationNavigation()
    @Published var isValidTitle = false
    @Published var isValidDescription = false
    
    var isIncomplete: Bool {
        !(isValidTitle && isValidDescription)
    }
    
    init() { }
    
    init(data: Curation) {
        self.curation = data
    }
    
    func fetchMakeCuration() {
        shortcutCells = shortcutsZipViewModel.fetchShortcutMakeCuration().sorted { $0.title < $1.title }
        if isEdit {
            deletedShortcutCells = curation.shortcuts
        }
        
        //isShortcutsTapped 초기화
        isShortcutsTapped = [Bool](repeating: false, count: shortcutCells.count)
        for shortcut in curation.shortcuts {
            if let index = shortcutCells.firstIndex(of: shortcut) {
                isShortcutsTapped[index] = true
            }
        }
    }
    
    func addCuration() {
        shortcutsZipViewModel.addCuration(curation: curation, isEdit: isEdit, deletedShortcutCells: deletedShortcutCells)
    }
    
    func checkboxCellTapGesture(index: Int) {
        if isShortcutsTapped[index] {
            isShortcutsTapped[index] = false
            // TODO: 현재는 name을 기준으로 검색중, id로 검색해서 삭제해야함 / Shortcuts 자체를 배열에 저장해야함
            
            if let firstIndex = curation.shortcuts.firstIndex(of: shortcutCells[index]) {
                curation.shortcuts.remove(at: firstIndex)
            }
        }
        else {
            if curation.shortcuts.count < 10 {
                curation.shortcuts.append(shortcutCells[index])
                isShortcutsTapped[index] = true
            }
        }
    }
}
