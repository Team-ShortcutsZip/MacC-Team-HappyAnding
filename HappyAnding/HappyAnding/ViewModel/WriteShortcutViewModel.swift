//
//  WriteShortcutViewModel.swift
//  HappyAnding
//
//  Created by JeonJimin on 2023/07/08.
//

import Foundation

final class WriteShortcutViewModel: ObservableObject {
    
    
    var shortcutsZipViewModel = ShortcutsZipViewModel.share
    var writeShortcutNavigation = WriteShortcutNavigation()
    
    @Published var isWriting: Bool
    
    @Published var isInfoButtonTouched = false
    
    @Published var isShowingIconModal = false
    @Published var isNameValid = false
    @Published var isLinkValid = false
    @Published var isOneLineValid = false
    @Published var isMultiLineValid = false
    @Published var isShowingCategoryModal = false
    @Published var isRequirementValid = false
    
    @Published var existingCategory: [String] = []
    @Published var newCategory: [String] = []
    
    @Published var shortcut = Shortcuts(sfSymbol: "",
                                    color: "",
                                    title: "",
                                    subtitle: "",
                                    description: "",
                                    category: [String](),
                                    requiredApp: [String](),
                                    numberOfLike: 0,
                                    numberOfDownload: 0,
                                    author: "",
                                    shortcutRequirements: "",
                                    downloadLink: [""],
                                    curationIDs: [String]())
    
    let isEdit: Bool
    
    
    init(isWriting: Bool, isEdit: Bool){
        self.isWriting = isWriting
        self.isEdit = isEdit
    }
    
    init(isWriting: Bool, isEdit: Bool, shortcut: Shortcuts){
        self.isWriting = isWriting
        self.isEdit = isEdit
        self.shortcut = shortcut
    }
    
    func uploadShortcut() {
        if let index = shortcutsZipViewModel.allShortcuts.firstIndex(where: {$0.id == shortcut.id}) {
            shortcutsZipViewModel.allShortcuts[index] = shortcut
        }
        
        shortcut.author = shortcutsZipViewModel.currentUser()
        if isEdit {
            //단축어 수정
            //뷰모델의 카테고리별 단축어 목록에서 정보 수정 및 해당 단축어가 포함된 큐레이션 수정
            shortcutsZipViewModel.updateShortcut(existingCategory: existingCategory, newCategory: shortcut.category, shortcut: shortcut)
            
        } else {
            //새로운 단축어 생성 및 저장
            // 뷰모델에 추가
            shortcutsZipViewModel.shortcutsMadeByUser.insert(shortcut, at: 0)
            
        }
        // 서버에 추가 또는 수정
        shortcutsZipViewModel.setData(model: shortcut)
        
        isWriting.toggle()
        
        if #available(iOS 16.1, *) {
            writeShortcutNavigation.navigationPath = .init()
        }
    }
    
    func isUnavailableUploadButton() -> Bool {
        shortcut.color.isEmpty ||
        shortcut.sfSymbol.isEmpty ||
        shortcut.title.isEmpty ||
        !isNameValid ||
        shortcut.downloadLink.isEmpty ||
        !isLinkValid ||
        shortcut.subtitle.isEmpty ||
        !isOneLineValid ||
        shortcut.description.isEmpty ||
        !isMultiLineValid || shortcut.category.isEmpty
    }
    
}
