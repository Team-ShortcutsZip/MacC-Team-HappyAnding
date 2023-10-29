//
//  FormViewModel.swift
//  HappyAnding
//
//  Created by HanGyeongjun on 10/29/23.
//

import Foundation

final class FormViewModel: ObservableObject {
    
    var shortcutsZipViewModel = ShortcutsZipViewModel.share
    
    @Published var form = Form(userInfo: "",
                               formContent: "")
    
    // 유저 설문을 Firebase에 업로드하는 함수
    func uploadUserForm(formContent: String) {
        form.userInfo = shortcutsZipViewModel.userInfo?.nickname ?? "nil"
        form.formContent = formContent
        shortcutsZipViewModel.setData(model: form)
    }
}
