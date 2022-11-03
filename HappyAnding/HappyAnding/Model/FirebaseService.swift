//
//  FirebaseService.swift
//  HappyAnding
//
//  Created by 전지민 on 2022/10/25.
//

import Foundation
import FirebaseCore
import FirebaseFirestore
import FirebaseAuth

class FirebaseService {
    static let share = FirebaseService()
    private let db = Firestore.firestore()
    
    func fetchShortcutCell(completionHandler: @escaping ([ShortcutCellModel])->()) {
        var shortcutCells: [ShortcutCellModel] = []
        
        db.collection("Shortcut").getDocuments() { (querySnapshot, error) in
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
                        let shortcutCell = ShortcutCellModel(
                            id: shortcut.id,
                            sfSymbol: shortcut.sfSymbol,
                            color: shortcut.color,
                            title: shortcut.title,
                            subtitle: shortcut.subtitle,
                            downloadLink: shortcut.downloadLink.last!
                        )
                        shortcutCells.append(shortcutCell)
                    } catch let error {
                        print("error: \(error)")
                    }
                }
                completionHandler(shortcutCells)
            }
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
    
    //Curation -> ShortcutDetail로 이동 시 Shortcut의 세부 정보를 가져오는 함수
    func fetchShortcutDetail(id: String, completionHandler: @escaping (Shortcuts)->()) {
        db.collection("Shortcut").whereField("id", isEqualTo: id).getDocuments { (querySnapshot, error) in
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
                        completionHandler(shortcut)
                    } catch let error {
                        print("error: \(error)")
                    }
                    print("\(document.documentID) => \(document.data())")
                }
            }
        }
    }
    
    // MARK: - shortcut Id 배열로 shortcut 배열 가져오는 함수
    
    func fetchShortcutByIds(shortcutIds: [String], completionHandler: @escaping ([Shortcuts])->()) {
        
        var shortcuts: [Shortcuts] = []
        
        for shortcutId in shortcutIds {
            db.collection("Shortcut")
                .whereField("id", isEqualTo: shortcutId)
                .getDocuments { (querySnapshot, error) in
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
    }
    
    //MARK: - user 닉네임 검사함수 - 중복이면 true, 중복되지않으면 false반환
    
    func checkNickNameDuplication(name: String, completionHandler: @escaping (Bool)->()) {
        
        var result = true
        
        db.collection("User")
            .whereField("nickname", isEqualTo: name)
            .limit(to: 1)
            .getDocuments() { (querySnapshot, error) in
                if let error {
                    print("Error getting documents: \(error)")
                } else {
                    guard let documents = querySnapshot?.documents else { return }
                    if documents.count == 0 {
                        result = false
                    }
                    completionHandler(result)
                }
            }
    }
    
    // MARK: - 현재 로그인한 아이디 리턴
    
    func currentUser() -> String {
        Auth.auth().currentUser?.uid ?? ""
    }
    
    // MARK: - 로그인한 아이디로 User 가져오는 함수
    
    func fetchUser(userID: String, completionHandler: @escaping (User)->()) {
        
        db.collection("User")
            .whereField("id", isEqualTo: userID)
            .getDocuments { (querySnapshot, error) in
                if let error {
                print("Error getting documents: \(error)")
            } else {
                guard let documents = querySnapshot?.documents else { return }
                let decoder = JSONDecoder()
                
                for document in documents {
                    do {
                        let data = document.data()
                        let jsonData = try JSONSerialization.data(withJSONObject: data)
                        let shortcut = try decoder.decode(User.self, from: jsonData)
                        completionHandler(shortcut)
                    } catch let error {
                        print("error: \(error)")
                    }
                }
            }
        }
    }
    
    //Shortcut 중에서 author가 testUser인 단축어만 가져오는 함수
    func fetchShortcutByAuthor(author: String, completionHandler: @escaping ([Shortcuts])->()) {
        
        var shortcuts: [Shortcuts] = []
        
        db.collection("Shortcut")
            .whereField("author", isEqualTo: author)
            .getDocuments { (querySnapshot, error) in
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
    
    func fetchUserShortcutByOrder(author: String, orderBy: String, completionHandler: @escaping ([Shortcuts])->()) {
        var shortcuts: [Shortcuts] = []
        
        db.collection("Shortcut")
            .whereField("author", isEqualTo: author)
            .order(by: orderBy, descending: true)
            .getDocuments() { (querySnapshot, error) in
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
                    print(shortcuts)
                }
            }
    }
    
    func fetchCurationByAuthor (author: String, completionHandler: @escaping ([Curation])->()) {
        
        var curations: [Curation] = []
        
        db.collection("Curation")
            .whereField("author", isEqualTo: author)
            .getDocuments { (querySnapshot, error) in
                if let error {
                print("Error getting documents: \(error)")
            } else {
                guard let documents = querySnapshot?.documents else { return }
                let decoder = JSONDecoder()
                
                for document in documents {
                    do {
                        let data = document.data()
                        let jsonData = try JSONSerialization.data(withJSONObject: data)
                        let curation = try decoder.decode(Curation.self, from: jsonData)
                        curations.append(curation)
                    } catch let error {
                        print("error: \(error)")
                    }
                }
                completionHandler(curations)
            }
        }
    }
    
    //카테고리의 좋아요 리스트
    func fetchCategoryLikedList(category: String, completionHandler: @escaping ([Shortcuts])->()) {
        
        var shortcutData:[Shortcuts] = []
        
        db.collection("Shortcut").whereField("category", arrayContains: category ).getDocuments { (querySnapshot, error) in
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
                        shortcutData.append(shortcut)
                    } catch let error {
                        print("error: \(error)")
                    }
                    print("\(document.documentID) => \(document.data())")
                }
                completionHandler(shortcutData)
            }
        }
    }
    
    //모든 단축어를 다운로드 수로 내림차순 정렬하여 가져오는 함수
    func fetchAllDownloadShortcut(orderBy: String, completionHandler: @escaping ([Shortcuts])->()) {
        var shortcuts: [Shortcuts] = []
        
        db.collection("Shortcut")
            .order(by: orderBy, descending: true)
            .getDocuments() { (querySnapshot, error) in
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
                    print(shortcuts)
                    completionHandler(shortcuts)
                }
            }
    }
    
    //카테고리에 해당하는 모든 단축어를 가져오는 함수
    func fetchCategoryShortcut(category: String, completionHandler: @escaping ([Shortcuts])->()) {
        var shortcuts: [Shortcuts] = []
        
        db.collection("Shortcut")
            .whereField("category", arrayContains: category )
            .getDocuments() { (querySnapshot, error) in
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
                    print(shortcuts)
                }
            }
    }
    //카테고리에 해당하는 모든 단축어를 정렬해서 가져오는 함수
    func fetchCategoryOrderedShortcut(category: String, orderBy: String, completionHandler: @escaping ([Shortcuts])->()) {
        var shortcuts: [Shortcuts] = []
        
        db.collection("Shortcut")
            .whereField("category", arrayContains: category)
            .order(by: orderBy, descending: true)
            .getDocuments() { (querySnapshot, error) in
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
                    print(shortcuts)
                }
            }
    }
    
    //모든 admin 큐레이션을 가져오는 함수
    func fetchAdminCuration(completionHandler: @escaping ([Curation])->()) {
        var curations: [Curation] = []
        
        db.collection("Curation")
            .whereField("idAdmin", isEqualTo: true )
            .getDocuments() { (querySnapshot, error) in
            if let error {
                print("Error getting documents: \(error)")
            } else {
                guard let documents = querySnapshot?.documents else { return }
                let decoder = JSONDecoder()
                for document in documents {
                    do {
                        let data = document.data()
                        let jsonData = try JSONSerialization.data(withJSONObject: data)
                        let curation = try decoder.decode(Curation.self, from: jsonData)
                        curations.append(curation)
                    } catch let error {
                        print("error: \(error)")
                    }
                }
                completionHandler(curations)
            }
        }
    }
    
    //내 큐레이션을 가져오는 함수 -> id 값 저장을 안해서 author를 기준으로 가져오기
    func fetchMyCuration(author: String, completionHandler: @escaping ([Curation])->()) {
        var curations: [Curation] = []
        
        db.collection("Curation")
            .whereField("author", isEqualTo: author )
            .getDocuments() { (querySnapshot, error) in
            if let error {
                print("Error getting documents: \(error)")
            } else {
                guard let documents = querySnapshot?.documents else { return }
                let decoder = JSONDecoder()
                for document in documents {
                    do {
                        let data = document.data()
                        let jsonData = try JSONSerialization.data(withJSONObject: data)
                        let curation = try decoder.decode(Curation.self, from: jsonData)
                        curations.append(curation)
                    } catch let error {
                        print("error: \(error)")
                    }
                }
                completionHandler(curations)
            }
        }
    }
    
    // TODO: 단축어 다운로드 정보 저장
    // TODO: UserID의 경우, Userdefault에 저장된 값을 가져오는 것으로 대체
    
    /// id: 단축어 id
    /// 단축어의 다운로드 수를 +1 하고, User의 다운로드 목록에 해당 단축어를 추가합니다.
    func updateDownloadInformation(shortcut: Shortcuts) {
        var shortcutInfo = shortcut
        shortcutInfo.numberOfDownload += 1
        db.collection("Shortcut").document(shortcut.id).setData(shortcutInfo.dictionary) { error in
            if let error {
                print(error.localizedDescription)
            }
        }
    }
    
    //TODO: Error 처리 필요
    
    func deleteData(model: Any) {
        switch model {
        case _ as Shortcut:
            db.collection("Shortcut").document((model as! Shortcuts).id).delete()
        case _ as Curation:
            db.collection("Curation").document((model as! Curation).id).delete()
        case _ as User:
            db.collection("User").document((model as! User).id).delete()
        default:
            print("this is not a model.")
        }
    }
    
    
    //TODO: Error 처리 필요
    
    func setData(model: Any) {
        switch model {
        case _ as Shortcuts:
            db.collection("Shortcut").document((model as! Shortcuts).id).setData((model as! Shortcuts).dictionary)
        case _ as Curation:
            db.collection("Curation").document((model as! Curation).id).setData((model as! Curation).dictionary)
        case _ as User:
            db.collection("User").document((model as! User).id).setData((model as! User).dictionary)
        default:
            print("this is not a model.")
        }
    }
}
