//
//  ReadCurationViewModel.swift
//  HappyAnding
//
//  Created by 이지원 on 2023/06/17.
//

import SwiftUI


final class ReadCurationViewModel: ObservableObject {
    var shortcutsZipViewModel = ShortcutsZipViewModel.share
    
    @Published var isWriting = false
    @Published var isTappedDeleteButton = false
    @Published var curation: Curation
    @Published var shortcuts = [ShortcutCellModel]()
    @Published var authInformation: User
    @Published var gradeImage = Image(systemName: "person.crop.circle.fill")
    @Published private(set) var isAdmin = false
    
    init(data: Curation) {
        self.curation = data
        self.authInformation = User()
        self.isAdmin = curation.isAdmin
        fetchUserGrade()
    }
    
    private func fetchUserGrade() {
        shortcutsZipViewModel.fetchUser(userID: curation.author,
                                        isCurrentUser: false) { user in
            self.authInformation = user
            let grade = self.shortcutsZipViewModel.checkShortcutGrade(userID: self.authInformation.id)
            let image = self.shortcutsZipViewModel.fetchShortcutGradeImage(isBig: false, shortcutGrade: grade)
            self.gradeImage = image
        }
    }
    
    func checkAuthor() -> Bool {
        return curation.author == shortcutsZipViewModel.currentUser()
    }
    
    func deleteCuration() {
        shortcutsZipViewModel.deleteData(model: curation)
        shortcutsZipViewModel.curationsMadeByUser = shortcutsZipViewModel.curationsMadeByUser.filter { $0.id != curation.id }
    }
    
    func shareCuration() {
        guard let deepLink = URL(string: "ShortcutsZip://myPage/CurationDetailView?curationID=\(curation.id)") else { return }
        
        let activityVC = UIActivityViewController(activityItems: [deepLink], applicationActivities: nil)
        let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene
        guard let window = windowScene?.windows.first else { return }
        window.rootViewController?.present(activityVC, animated: true, completion: nil)
    }
}

