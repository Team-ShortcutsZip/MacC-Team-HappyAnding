//
//  ShortcutsZipViewModel.swift
//  HappyAnding
//
//  Created by KiWoong Hong on 2022/11/01.
//

import SwiftUI
import FirebaseCore
import FirebaseFirestore
import FirebaseAuth

/*
 PR 단위 끊을 꺼
 shortcuts View Model 작성
 shortcuts View Model 적용 (ExploreShortcutView 위주)
 Curation View Model 작성
 Curation View Model 적용 (ExploreCurationView 위주)
 User View Model 작성
 User View Model 적용 (ExploreShortcutView, ExploreCurationView에서 필요한 뷰)
 ShortcutsZip View Mdoel 전체 적용 (MyPageView 위주)
 
 */
class ShortcutsZipViewModel: ObservableObject {
    
    @Published var shortcuts: [Shortcuts] = []
    
    static let share = FirebaseService()
    private let db = Firestore.firestore()
    
    init() {
        fetchShortcut(model: "Shortcut") { shortcuts in
            self.shortcuts = shortcuts
        }
    }
    
    //MARK: - 모든 Shortcut을 가져오는 함수
    
    func fetchShortcut(model: String, completionHandler: @escaping ([Shortcuts])->()) {
        var shortcuts: [Shortcuts] = []
        
        db.collection(model).getDocuments() { (querySnapshot, error) in
            if let error {
                print("Error getting documents: \(error)")
            } else {
                guard let documents = querySnapshot?.documents else { return }
                let decoder = JSONDecoder()
                for document in documents {
                    do {
                        let data = document.data()
                        let jsonData = try JSONSerialization.data(withJSONObject: data)
                        let shortcut = try decoder.decode(Shortcuts.self, from: jsonData)
                        shortcuts.append(shortcut)
                    } catch let error {
                        print("error: \(error)")
                    }
                }
                completionHandler(shortcuts)
            }
        }
    }
    
    // MARK: shortcuts을 Download 순으로 정렬하는 함수
    
    func sortedShortcutsByDownload() -> [Shortcuts] {
        self.shortcuts.sorted {
            $0.numberOfDownload > $1.numberOfDownload
        }
    }
    
    // MARK: shortcuts을 Like 순으로 정렬하는 함수
    
    func sortedshortcutsByLike() -> [Shortcuts] {
        self.shortcuts.sorted {
            $0.numberOfLike > $1.numberOfLike
        }
    }
}
