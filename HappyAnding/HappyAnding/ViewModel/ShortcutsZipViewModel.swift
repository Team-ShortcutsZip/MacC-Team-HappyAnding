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
    
    @Published var userInfo: User?                              // 유저정보
    
    @Published var shortcutsUserLiked: [Shortcuts] = []         // 유저가 좋아요한 숏컷들
    @Published var shortcutsUserDownloaded: [Shortcuts] = []    // 유저가 다운로드한 숏컷들
    @Published var shortcutsMadeByUser: [Shortcuts] = []        // 유저가 만든 숏컷배열
    @Published var sortedShortcutsByDownload: [Shortcuts] = []  // 다운로드 수에 의해 정렬된 숏컷
    @Published var sortedShortcutsByLike: [Shortcuts] = []  // 다운로드 수에 의해 정렬된 숏컷
    @Published var shortcutsInCategory: [[Shortcuts]] = [[Shortcuts]].init(repeating: [], count: Category.allCases.count) // Category에서 사용할 숏컷 배열
    @Published var isFirstFetchInCategory = [Bool] (repeating: true, count: Category.allCases.count) //카테고리를 리스트 첫 fetch여부
    @Published var isLastFetchInCategory = [Bool] (repeating: false, count: Category.allCases.count) //카테고리를 리스트 마지막 fetch여부
    
    @Published var curationsMadeByUser: [Curation] = []         // 유저가 만든 큐레이션배열
    @Published var userCurations: [Curation] = []
    @Published var adminCurations: [Curation] = []
    
    @Published var keywords: Keyword = Keyword(keyword: [String]())
    
    static let share = ShortcutsZipViewModel()
    private let db = Firestore.firestore()
    
    var lastShortcutDocumentSnapshot = [QueryDocumentSnapshot?] (repeating: nil, count: 3)
    var lastCurationDocumentSnapshot = [QueryDocumentSnapshot?] (repeating: nil, count: 3)
    var lastCategoryDocumentSnapshot = [QueryDocumentSnapshot?] (repeating: nil, count: 12)
    var lastSearchShortcutDocumentSnapshot: QueryDocumentSnapshot?
    
    let numberOfPageLimit = 10
    let numberOfLike = 5
    
    init() {
        
        fetchShortcutLimit(orderBy: "numberOfDownload") { shortcuts in
            self.sortedShortcutsByDownload = shortcuts
        }
        fetchShortcutLimitByLiked { shortcuts in
            self.sortedShortcutsByLike = shortcuts
        }
        fetchCurationLimit(isAdmin: true) { curations in
            self.adminCurations = curations
        }
        fetchCurationLimit(isAdmin: false) { curations in
            self.userCurations = curations
        }
        initUserInfo()
        fetchKeyword { keywords in
            self.keywords = keywords
        }
    }
    
    func initUserInfo() {
        fetchShortcutByAuthor(author: currentUser()) { shortcuts in
            self.shortcutsMadeByUser = shortcuts
        }
        fetchCurationByAuthor(author: currentUser()) { curations in
            self.curationsMadeByUser = curations
        }
        fetchUser(userID: self.currentUser()) { user in
            self.userInfo = user
            user.downloadedShortcuts.forEach { downloadedShortcut in
                self.fetchShortcutDetail(id: downloadedShortcut.id) { shortcut in
                    self.shortcutsUserDownloaded.append(shortcut)
                }
            }
            self.fetchShortcutByIds(shortcutIds: user.likedShortcuts) { likedShortcuts in
                self.shortcutsUserLiked = likedShortcuts
            }
        }
    }
    
    //MARK: 키워드 받아오는 함수
    func fetchKeyword(completionHandler: @escaping (Keyword)->()) {
        var _: [String] = []
        db.collection("Keyword").getDocuments { querySnapshot, error in
            if let error {
                print("Error getting documents: \(error)")
            } else {
                guard let documents = querySnapshot?.documents else { return }
                let decoder = JSONDecoder()
                for document in documents {
                    do {
                        let data = document.data()
                        let jsonData = try JSONSerialization.data(withJSONObject: data)
                        let keyword = try decoder.decode(Keyword.self, from: jsonData)
                        completionHandler(keyword)
                    } catch let error {
                        print("error: \(error)")
                    }
                }
            }
        }
    }
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
    
    
//MARK: - 데이터를 받아오는 함수들
    
    //MARK: - 단축어
    
    //MARK: 단축어를 (다운로드 수, 좋아요 수) 정렬 및 10개씩 가져오는 함수 (단축어 둘러보기)
    
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
    
    //MARK: 좋아요가 numberOfLike보다 크거나 같은 단축어를 10개씩 가져오는 함수 (단축어 둘러보기)
    
    func fetchShortcutLimitByLiked(completionHandler: @escaping ([Shortcuts])->()) {
            
            var shortcuts: [Shortcuts] = []
            var query: Query!
            let index = 1
            
            if let next = self.lastShortcutDocumentSnapshot[index] {
                query  = db.collection("Shortcut")
                    .whereField("numberOfLike", isGreaterThan: numberOfLike)
                    .limit(to: numberOfPageLimit)
                    .start(afterDocument: next)
            } else {
                query = db.collection("Shortcut")
                    .whereField("numberOfLike", isGreaterThan: numberOfLike)
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
    
    //MARK: 선택한 카테고리에 해당하는 단축어를 정렬하여 10개씩 가져오는 함수 (카테고리 단축어)
    
    func fetchCategoryShortcutLimit(
        category: Category,
        orderBy: String,
        completionHandler: @escaping ([Shortcuts])->()) {
            var shortcuts: [Shortcuts] = []
            
            var query: Query!
            let index = category.index
            
            if let next = self.lastCategoryDocumentSnapshot[index] {
                query  = db.collection("Shortcut")
                    .whereField("category", arrayContains: category.rawValue)
                    .order(by: orderBy, descending: true)
                    .limit(to: numberOfPageLimit)
                    .start(afterDocument: next)
            } else {
                query = db.collection("Shortcut")
                    .whereField("category", arrayContains: category.rawValue)
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
                    self.lastCategoryDocumentSnapshot[category.index] = documents.last
                    completionHandler(shortcuts)
                }
            }
        }
    
    // MARK: 현재 user가 만들었던 shortcuts을 10개씩 받아오는 함수 (나의 단축어)
    
    func fetchShortcutByAuthor(author: String, completionHandler: @escaping ([Shortcuts])->()) {
        
        var shortcuts: [Shortcuts] = []
        
        db.collection("Shortcut")
            .whereField("author", isEqualTo: author)
            .order(by: "date", descending: true)
//            .limit(to: numberOfPageLimit)
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
    
    // MARK: shortcut Id 배열로 shortcut 배열 가져오는 함수
    
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
    
    //MARK: Curation -> ShortcutDetail로 이동 시 Shortcut의 세부 정보를 가져오는 함수
    
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
                }
            }
        }
    }
    
    //MARK: ReadShortcutView에서 해당 단축어에 좋아요를 눌렀는지 확인하는 함수 completionHandler로 bool값을 전달
    
    func checkLikedShortrcut(shortcutID: String, completionHandler: @escaping (Bool)->()) {
        var result = false
        fetchUser(userID: currentUser()) { data in
            result = data.likedShortcuts.contains(shortcutID)
            completionHandler(result)
        }
    }
    
    //MARK: 현재 사용자가 작성한 Shortcuts -> ShortcutCellModel 형태로 변환하여 가져오는 함수 -> 큐레이션 작성
    
    func fetchMadeShortcutCell(completionHandler: @escaping ([ShortcutCellModel])->()) {
        var shortcutCells: [ShortcutCellModel] = []
        
        db.collection("Shortcut")
            .whereField("author", isEqualTo: currentUser())
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
    
    // MARK: 현재 사용자가 좋아요한 Shortcuts -> ShortcutCellModel 형태로 변환 -> 큐레이션 작성
    
    func fetchLikedShortcutCell(completionHandler: @escaping ([ShortcutCellModel])->()) {
        var shortcutCells: [ShortcutCellModel] = []
        
        self.fetchUser(userID: self.currentUser()) { user in
            let shortcutIds = user.likedShortcuts
            
            for shortcutId in shortcutIds {
                self.db.collection("Shortcut")
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
        }
    }
    
    
    //MARK: - 큐레이션
    
    
    // MARK: Author에 의한 큐레이션들 받아오는 함수 (나의 큐레이션)
    
    func fetchCurationByAuthor (author: String, completionHandler: @escaping ([Curation])->()) {
        
        let index = 2
        var curations: [Curation] = []
        
        db.collection("Curation")
            .whereField("author", isEqualTo: author)
            .order(by: "dateTime", descending: true)
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
                    self.lastCurationDocumentSnapshot[index] = documents.last
                    completionHandler(curations)
                }
            }
    }
    
    //MARK: Curation을 (admin, user) 구분하여 10개씩 가져오는 함수
    
    func fetchCurationLimit(isAdmin: Bool, completionHandler: @escaping ([Curation])->()) {
        var curations: [Curation] = []
        
        var query: Query!
        let index = checkCurationIndex(isAdmin: isAdmin)
        
        if let next = self.lastCurationDocumentSnapshot[index] {
            query  = db.collection("Curation")
                .whereField("isAdmin", isEqualTo: isAdmin)
                .order(by: "dateTime", descending: true)
                .limit(to: numberOfPageLimit)
                .start(afterDocument: next)
        } else {
            query = db.collection("Curation")
                .whereField("isAdmin", isEqualTo: isAdmin)
                .order(by: "dateTime", descending: true)
                .limit(to: numberOfPageLimit)
        }
        
        query.addSnapshotListener { snapshot, error in
            guard let snapshot else {
                print("Error fetching snapshots: \(error!)")
                return
            }
            snapshot.documentChanges.forEach { diff in
                let decoder = JSONDecoder()
                
                do {
                    let data = diff.document.data()
                    let jsonData = try JSONSerialization.data(withJSONObject: data)
                    let curation = try decoder.decode(Curation.self, from: jsonData)
                    
                    if (diff.type == .added) {
                        curations.insert(curation, at: 0)
                    }
                    if (diff.type == .modified) {
                        if let index = curations.firstIndex(where: { $0.id == curation.id}) {
                            curations[index] = curation
                        }
                        if let authorCurationIndex = self.curationsMadeByUser.firstIndex(where: { $0.id == curation.id}) {
                            self.curationsMadeByUser[authorCurationIndex] = curation
                        }
                        if let adminCurationIndex = self.adminCurations.firstIndex(where: { $0.id == curation.id}) {
                            self.adminCurations[adminCurationIndex] = curation
                        }
                    }
                    if (diff.type == .removed) {
                        curations.removeAll(where: { $0.id == curation.id})
                    }
                    self.lastCurationDocumentSnapshot[index] = diff.document
                } catch let error {
                    print("error: \(error)")
                }
            }
            completionHandler(curations)
        }
    }
    
    
    
//MARK: - 저장, 편집 관련 함수
    
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
    
    //MARK: 단축어 수정 시 해당 단축어가 포함된 큐레이션 서버 데이터를 업데이트하는 함수 -> 단축어 정보 업데이트
    
    func updateShortcutInCuration(shortcutCell: ShortcutCellModel, curationIDs: [String]) {
        for curationID in curationIDs {
            db.collection("Curation")
                .whereField("id", isEqualTo: curationID)
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
                                var curation = try decoder.decode(Curation.self, from: jsonData)
                                
                                //서버 데이터 업데이트
                                if let index = curation.shortcuts.firstIndex(where: { $0.id == shortcutCell.id }) {
                                    curation.shortcuts[index] = shortcutCell
                                }
                                self.setData(model: curation)
                                //뷰모델 업데이트
                            } catch let error {
                                print("error: \(error)")
                            }
                        }
                    }
                }
        }
        
    }
    
//    func updateShortcutInCurationUI(curation: Curation, curationIDs: [String]) {
//        curationIDs.forEach { curationID in
//            if let userCurationsIndex = self.userCurations.firstIndex(where: { $0.id == curationID }) {
//                self.userCurations[userCurationsIndex] = curation
//            }
//            if let adminCurationsIndex = self.adminCurations.firstIndex(where: { $0.id == curationID }) {
//                self.adminCurations[adminCurationsIndex] = curation
//            }
//            if let curationsMadeByUserIndex = self.curationsMadeByUser.firstIndex(where: { $0.id == curationID }) {
//                self.curationsMadeByUser[curationsMadeByUserIndex] = curation
//            }
//        }
//    }
    
    //MARK: 좋아요 수를 업데이트하는 함수
    
    func updateNumberOfLike(isMyLike: Bool, shortcut: Shortcuts) {
        var increment = 0
        if isMyLike {
            increment = 1
            self.fetchUser(userID: self.currentUser()) { data in
                var user = data
                user.likedShortcuts.append(shortcut.id)
                
                self.db.collection("User").document(user.id).setData(user.dictionary) { error in
                    if let error {
                        print(error.localizedDescription)
                    }
                }
            }
        } else {
            increment = -1
            self.fetchUser(userID: self.currentUser()) { data in
                var user = data
                user.likedShortcuts.removeAll(where: { $0 == shortcut.id })
                
                self.db.collection("User").document(user.id).setData(user.dictionary) { error in
                    if let error {
                        print(error.localizedDescription)
                    }
                }
            }
        }
        db.collection("Shortcut").document(shortcut.id)
            .updateData([
                "numberOfLike" : FieldValue.increment(Int64(increment))
            ]) { error in
                if let error {
                    print(error.localizedDescription)
                }
            }
    }
    
    //MARK: 다운로드 수를 업데이트하는 함수
    
    func updateNumberOfDownload(shortcut: Shortcuts) {
        if let index = userInfo?.downloadedShortcuts.firstIndex(where: { $0.id == shortcut.id}) {
            if userInfo?.downloadedShortcuts[index].downloadLink != shortcut.downloadLink[0] {
                self.userInfo!.downloadedShortcuts[index].downloadLink = shortcut.downloadLink[0]
                if let userInfo = self.userInfo {
                    self.setData(model: userInfo)
                }
            }
        } else {
            self.db.collection("Shortcut").document(shortcut.id)
                .updateData([
                    "numberOfDownload" : FieldValue.increment(Int64(1))
                ]) { error in
                    if let error {
                        print(error.localizedDescription)
                    }
                }
            let downloadShortcut = DownloadedShortcut(id: shortcut.id, downloadLink: shortcut.downloadLink[0])
            userInfo?.downloadedShortcuts.insert(downloadShortcut, at: 0)
            if let userInfo = self.userInfo {
                self.setData(model: userInfo)
            }
        }
    }
    
    //MARK: 단축어 버전 업데이트하는 함수
    
    func updateShortcutVersion(shortcut: Shortcuts, updateDescription: String, updateLink: String) {
        var data = shortcut
        
        //서버 - 단축어 업데이트
        data.downloadLink.insert(updateLink, at: 0)
        data.updateDescription.insert(updateDescription, at: 0)
        setData(model: data)
        
        //서버 - 큐레이션 업데이트
        let shortcutCell = ShortcutCellModel(
            id: data.id,
            sfSymbol: data.sfSymbol,
            color: data.color,
            title: data.title,
            subtitle: data.subtitle,
            downloadLink: data.downloadLink[0]
        )
        updateShortcutInCuration(shortcutCell: shortcutCell, curationIDs: data.curationIDs)
        
        //뷰모델 - 단축어 업데이트
        
        //다운로드순 정렬 단축어
        if let index = sortedShortcutsByDownload.firstIndex(where: { $0.id == shortcut.id}) {
            sortedShortcutsByDownload[index] = shortcut
        }
        // 좋아요 정렬 단축어
        if let index = sortedShortcutsByLike.firstIndex(where: { $0.id == shortcut.id}) {
            sortedShortcutsByLike[index] = shortcut
        }
        //내가 다운로드 한
        if let index = shortcutsUserDownloaded.firstIndex(where: { $0.id == shortcut.id}) {
            shortcutsUserDownloaded[index] = shortcut
        }
        //내가 좋아요 한
        if let index = shortcutsUserLiked.firstIndex(where: { $0.id == shortcut.id}) {
            shortcutsUserLiked[index] = shortcut
        }
        //내가 작성한
        if let index = shortcutsMadeByUser.firstIndex(where: { $0.id == shortcut.id}) {
            shortcutsMadeByUser[index] = shortcut
        }
        //카테고리별 단축어
        shortcut.category.forEach { category in
            if let index = shortcutsInCategory[Category(rawValue: category)!.index].firstIndex(where: { $0.id == shortcut.id}) {
                shortcutsInCategory[Category(rawValue: category)!.index][index] = shortcut
            }
        }
    }
    
    //MARK: 큐레이션 생성 시 포함된 단축어에 큐레이션 아이디를 저장하는 함수
    
    func updateShortcutCurationID (shortcutCells: [ShortcutCellModel], curationID: String) {
        shortcutCells.forEach { shortcutCell in
            fetchShortcutDetail(id: shortcutCell.id) { data in
                var shortcut = data
                shortcut.curationIDs.append(curationID)
                self.setData(model: shortcut)
            }
        }
    }
    
    
//MARK: - 삭제 관련 함수
    
    //TODO: Error 처리 필요
    
    func deleteData(model: Any) {
        switch model {
        case _ as Shortcuts:
            db.collection("Shortcut").document((model as! Shortcuts).id).delete()
        case _ as Curation:
            db.collection("Curation").document((model as! Curation).id).delete()
        case _ as User:
            db.collection("User").document((model as! User).id).delete()
        default:
            print("this is not a model.")
        }
    }
    
    //MARK: 단축어 삭제 시 유저 정보에 포함된 id 삭제하는 함수
    
    func deleteShortcutIDInUser(shortcutID: String) {
        
        //좋아요한 목록에서 삭제
        db.collection("User")
            .whereField("likedShortcuts", arrayContains: shortcutID)
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
                            var user = try decoder.decode(User.self, from: jsonData)
                            
                            user.likedShortcuts.removeAll(where: { $0 == shortcutID })
                            user.downloadedShortcuts.removeAll(where: { $0.id == shortcutID })
                            self.setData(model: user)
                            
                        } catch let error {
                            print("error: \(error)")
                        }
                    }
                }
            }
        
        //다운로드한 목록에서 삭제
        db.collection("User")
            .whereField("downloadedShortcuts", arrayContains: shortcutID)
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
                            var user = try decoder.decode(User.self, from: jsonData)
                            
                            user.downloadedShortcuts.removeAll(where: { $0.id == shortcutID })
                            user.likedShortcuts.removeAll(where: { $0 == shortcutID })
                            self.setData(model: user)
                            
                        } catch let error {
                            print("error: \(error)")
                        }
                    }
                }
            }
    }
    
    //MARK: 단축어 삭제 시 해당 단축어를 포함하는 큐레이션에서 삭제하는 함수
    
    func deleteShortcutInCuration(curationsIDs: [String], shortcutID: String) {
        curationsIDs.forEach { curationID in
            db.collection("Curation")
                .whereField("id", isEqualTo: curationID)
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
                                var curation = try decoder.decode(Curation.self, from: jsonData)
                                
                                curation.shortcuts.removeAll(where: { $0.id == shortcutID })
                                self.setData(model: curation)
                                    
                            } catch let error {
                                print("error: \(error)")
                            }
                        }
                    }
                }
        }
    }
    
    //MARK: 큐레이션 삭제 시 단축어의 curationIDs에서 id삭제하는 함수
    
    func deleteCurationIDInShortcut(curationID: String) {
        db.collection("Shortcut")
            .whereField("curationIDs", arrayContains: curationID)
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
                            var shortcut = try decoder.decode(Shortcuts.self, from: jsonData)
                            
                            shortcut.curationIDs.removeAll(where: {$0 == curationID})
                            self.setData(model: shortcut)
                            
                        } catch let error {
                            print("error: \(error)")
                        }
                    }
                }
            }
    }
    
    
//MARK: - 유저 관련 함수
    
    // MARK: 현재 로그인한 아이디 리턴
    
    func currentUser() -> String {
        Auth.auth().currentUser?.uid ?? ""
    }
    
    //MARK: 로그인한 아이디로 User 가져오는 함수
    
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
    
    //MARK: user 닉네임 검사함수 - 중복이면 true, 중복되지않으면 false반환
    
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
    
    // MARK: 이미 회원가입한 User인지 확인하는 함수
    
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
    
// MARK: - 검색 관련 함수
    
    //MARK: 연관 앱으로 단축어 검색
    func searchShortcutByRequiredApp(word: String, completionHandler: @escaping ([Shortcuts]) -> ()) {
        var shortcuts: [Shortcuts] = []
        
        var query: Query!
        
        query = db.collection("Shortcut")
            .whereField("requiredApp", arrayContains: word)
            .order(by: "requiredApp", descending: true)
        
        query.getDocuments { (querySnapshot, error) in
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
                self.lastSearchShortcutDocumentSnapshot = documents.last
                completionHandler(shortcuts)
            }
        }
    }
    
    //MARK: 제목으로 단축어 검색
    ///prefix기준으로만 검색이 가능
    func searchShortcutByTitlePrefix(keyword: String, completionHandler: @escaping ([Shortcuts]) -> ()) {
        var shortcuts: [Shortcuts] = []
        
        var query: Query!
        
        query = db.collection("Shortcut")
            .whereField("title", isGreaterThanOrEqualTo: keyword)
            .whereField("title", isLessThanOrEqualTo: keyword + "\u{f8ff}")
        
        query.getDocuments { (querySnapshot, error) in
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
                self.lastSearchShortcutDocumentSnapshot = documents.last
                completionHandler(shortcuts)
            }
        }
    }
    func fetchComment(shortcutID: String, completionHandler: @escaping (Comments) -> ()) {
        db.collection("Comment")
            .whereField("id", isEqualTo: shortcutID)
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
                            let comments = try decoder.decode(Comments.self, from: jsonData)
                            completionHandler(comments)
                        } catch let error {
                            print("error: \(error)")
                        }
                    }
                }
            }
    }
}
