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
    shortcutsZip 앱 내에서 각 뷰에 필요한 데이터를 전달하기위한 ViewModel Class 입니다.
    * 해당 class 내부에 있는 함수의 자세한(?) 설명은 MARK를 참조해주세요 *
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
    
    // MARK: - 파이어스토어에서 모든 Shortcut을 가져오는 함수
    
    private func fetchShortcut(model: String, completionHandler: @escaping ([Shortcuts])->()) {
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
    
    //MARK: - 파이어스토어에서 모든 Curation을 가져오는 함수
    
    private func fetchCuration(completionHandler: @escaping ([Curation])->()) {
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
    
    // MARK: Curation 데이터에서 Admin Curation을 분류시키는 함수
    
    func classifyAdminCuration() -> [Curation] {
        self.curations.filter {
            $0.isAdmin
        }
    }
    
    // MARK: Curation 데이터에서 User Curation을 분류시키는 함수
    
    func classifyUserCuration() -> [Curation] {
        self.curations.filter {
            $0.isAdmin == false
        }
    }
    
}
