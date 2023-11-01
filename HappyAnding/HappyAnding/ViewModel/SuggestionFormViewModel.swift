//
//  SuggestionFormViewModel.swift
//  HappyAnding
//
//  Created by HanGyeongjun on 10/29/23.
//

import Foundation

final class SuggestionFormViewModel: ObservableObject {
    
    private let shortcutsZipViewModel = ShortcutsZipViewModel.share
    
    @Published var suggstionForm = SuggestionForm()
    
    // 유저 설문을 Firebase에 업로드하는 함수
    func uploadUserForm(formContent: String) {
        suggstionForm.userInfo = shortcutsZipViewModel.userInfo?.nickname ?? "nil"
        suggstionForm.formContent = formContent
        shortcutsZipViewModel.setData(model: suggstionForm)
    }
}
