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
    
    var lastShortcutDocumentSnapshot = [QueryDocumentSnapshot?] (repeating: nil, count: 3)
    var lastCurationDocumentSnapshot = [QueryDocumentSnapshot?] (repeating: nil, count: 3)
    let numberOfPageLimit = 10
    
    //MARK: 단축어 정렬기준에 따라 마지막 데이터가 저장된 인덱스 값을 반환하는 함수
    
    func checkShortcutIndex(orderBy: String) -> Int {
        
        var index = -1
        
        switch orderBy {
        case "numberOfDownload":
            index = 0
        case "numberOfLike":
            index = 1
        case "author":
            index = 2
        default:
            index = 0
        }
        return index
    }
    
    //MARK: 큐레이션 정렬기준에 따라 마지막 데이터가 저장된 인덱스 값을 반환하는 함수
    
    func checkCurationIndex(isAdmin: Bool) -> Int {
        
        var index = -1
        
        switch isAdmin {
        case true:
            index = 0
        case false:
            index = 1
        }
        return index
    }
    
    //MARK: - 모든 단축어를 Shortcuts -> ShortcutCellModel 형태로 변환하여 가져오는 함수
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
                completionHandler(curations)
            }
        }
    }
    
    //MARK: - 단축어를 (다운로드 수, 좋아요 수) 정렬 및 10개씩 가져오는 함수
    
    func fetchShortcutLimit(
        orderBy: String,
        completionHandler: @escaping ([Shortcuts])->()) {
            
            var shortcuts: [Shortcuts] = []
            var query: Query!
            let index = checkShortcutIndex(orderBy: orderBy)
            
            if let next = self.lastShortcutDocumentSnapshot[index] {
                query  = db.collection("Shortcut")
                    .order(by: orderBy, descending: true)
                    .limit(to: numberOfPageLimit)
                    .start(afterDocument: next)
            } else {
                query = db.collection("Shortcut")
                    .order(by: orderBy, descending: true)
                    .limit(to: numberOfPageLimit)
            }
            
            query.getDocuments() { querySnapshot, error in
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
                    self.lastShortcutDocumentSnapshot[index] = documents.last
                    
                    completionHandler(shortcuts)
                }
            }
        }
    
    //MARK: - 선택한 카테고리에 해당하는 단축어를 정렬하여 10개씩 가져오는 함수
    
    func fetchCategoryShortcutLimit(
        category: String,
        orderBy: String,
        completionHandler: @escaping ([Shortcuts])->()) {
            
            var shortcuts: [Shortcuts] = []
            
            var query: Query!
            let index = checkShortcutIndex(orderBy: orderBy)
            
            if let next = self.lastShortcutDocumentSnapshot[index] {
                query  = db.collection("Shortcut")
                    .whereField("category", arrayContains: category)
                    .order(by: orderBy, descending: true)
                    .limit(to: numberOfPageLimit)
                    .start(afterDocument: next)
            } else {
                query = db.collection("Shortcut")
                    .whereField("category", arrayContains: category)
                    .order(by: orderBy, descending: true)
                    .limit(to: numberOfPageLimit)
            }
            
            query.getDocuments() { (querySnapshot, error) in
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
                    self.lastShortcutDocumentSnapshot[index] = documents.last
                    completionHandler(shortcuts)
                }
            }
        }
    
    //MARK: - Curation을 (admin, user) 구분하여 10개씩 가져오는 함수
    
    func fetchCurationLimit(isAdmin: Bool, completionHandler: @escaping ([Curation])->()) {
        var curations: [Curation] = []
        
        var query: Query!
        let index = checkCurationIndex(isAdmin: isAdmin)
        
        if let next = self.lastCurationDocumentSnapshot[index] {
            query  = db.collection("Curation")
                .whereField("isAdmin", isEqualTo: isAdmin)
                .limit(to: numberOfPageLimit)
                .start(afterDocument: next)
        } else {
            query = db.collection("Curation")
                .whereField("isAdmin", isEqualTo: isAdmin)
                .limit(to: numberOfPageLimit)
        }
        
        query.getDocuments() { (querySnapshot, error) in
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
                self.lastCurationDocumentSnapshot[index] = documents.last
                completionHandler(curations)
            }
        }
    }
    
    //MARK: - 전체 Curation을 10개씩 가져오는 함수
    
    func fetchAllCurationLimit(completionHandler: @escaping ([Curation])->()) {
        var curations: [Curation] = []
        
        var query: Query!
        let index = 2
        
        if let next = self.lastCurationDocumentSnapshot[index] {
            query  = db.collection("Curation")
                .limit(to: numberOfPageLimit)
                .start(afterDocument: next)
        } else {
            query = db.collection("Curation")
                .limit(to: numberOfPageLimit)
        }
        
        query.getDocuments() { (querySnapshot, error) in
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
                self.lastCurationDocumentSnapshot[index] = documents.last
                completionHandler(curations)
            }
        }
    }
    
    //MARK: - Curation -> ShortcutDetail로 이동 시 Shortcut의 세부 정보를 가져오는 함수
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
    
    func updateData(shortcut: Shortcuts, user: User) {
        var shortcutInfo = shortcut
        var userInfo = user
        
        shortcutInfo.numberOfDownload += 1
        userInfo.likedShortcuts
        db.collection("Shortcut").document(shortcut.id).setData(shortcutInfo.dictionary) { error in
            if let error {
                print(error.localizedDescription)
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
    
    
    // MARK: - 이미 회원가입한 User인지 확인하는 함수
    
    func checkMembership(completionHandler: @escaping (Bool) -> ()) {
        
        var result = true
        
        db.collection("User")
            .whereField("id", isEqualTo: currentUser())
            .limit(to: 1)
            .getDocuments() { (querySnapshot, error) in
                if let error {
                    print("Error getting documnets: \(error)")
                } else {
                    guard let documents = querySnapshot?.documents else { return }
                    if documents.count == 0 {
                        result = false
                    }
                    completionHandler(result)
                }
            }
    }
}
