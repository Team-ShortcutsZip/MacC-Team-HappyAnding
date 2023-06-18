//
//  ReadCurationViewModel.swift
//  HappyAnding
//
//  Created by kimjimin on 2023/06/18.
//

import SwiftUI

class ReadCurationViewModel: ObservableObject {
    @StateObject var shortcutsZipViewModel = ShortcutsZipViewModel()
    
    @Published var authorInformation: User? = nil
    @Published var isWriting = false
    @Published var isTappedDeleteButton = false
    @Published var index = 0
    
    let data: NavigationReadCurationType

    init(data: NavigationReadCurationType) {
        self.data = data
        fetchAuthorInformation()
    }
    
    func fetchAuthorInformation() {
        shortcutsZipViewModel.fetchUser(userID: data.curation.author, isCurrentUser: false) { user in
            self.authorInformation = user
        }
    }
    
    func deleteCuration() {
        shortcutsZipViewModel.deleteData(model: data.curation)
        shortcutsZipViewModel.curationsMadeByUser = shortcutsZipViewModel.curationsMadeByUser.filter { $0.id != data.curation.id }
    }
    
    func shareCuration() {
        guard let deepLink = URL(string: "ShortcutsZip://myPage/CurationDetailView?curationID=\(data.curation.id)") else { return }
        
        let activityVC = UIActivityViewController(activityItems: [deepLink], applicationActivities: nil)
        let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene
        guard let window = windowScene?.windows.first else { return }
        window.rootViewController?.present(activityVC, animated: true, completion: nil)
    }
}
