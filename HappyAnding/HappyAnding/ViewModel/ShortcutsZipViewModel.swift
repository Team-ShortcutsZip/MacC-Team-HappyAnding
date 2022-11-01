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
 Curation View Model 작성
 Curation View Model 적용 (ExploreCurationView 위주)
 User View Model 작성
 User View Model 적용 (ExploreShortcutView, ExploreCurationView에서 필요한 뷰)
 ShortcutsZip View Mdoel 전체 적용 (MyPageView 위주)
 
 */
class ShortcutsZipViewModel: ObservableObject {
    
    @Published var shortcuts: [Shortcuts] = []
    @Published var curations: [Curation] = []
    
    static let share = FirebaseService()
    private let db = Firestore.firestore()
    
    init() {
        fetchShortcut(model: "Shortcut") { shortcuts in
            self.shortcuts = shortcuts
        }
        fetchCuration { curations in
            self.curations = curations
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
    
    //MARK: - 모든 Curation을 가져오는 함수
    
    func fetchCuration(completionHandler: @escaping ([Curation])->()) {
        var curations: [Curation] = []
        
        db.collection("Curation").getDocuments() { (querySnapshot, error) in
            if let error {
                print("Error getting documents: \(error)")
            } else {
                guard let documents = querySnapshot?.documents else { return }
                let decoder = JSONDecoder()
                for document in documents {
                    do {
                        let data = document.data()
                        let jsonData = try JSONSerialization.data(withJSONObject: data)
                        let shortcut = try decoder.decode(Curation.self, from: jsonData)
                        curations.append(shortcut)
                    } catch let error {
                        print("error: \(error)")
                    }
                }
                print(curations)
                completionHandler(curations)
            }
        }
    }
    
    func classifyAdminCuration() -> [Curation] {
        self.curations.filter {
            $0.isAdmin
        }
    }
    
    func classifyUserCuration() -> [Curation] {
        self.curations.filter {
            $0.isAdmin == false
        }
    }
    
}
