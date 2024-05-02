//
//  ShortcutsZipViewModel.swift
//  HappyAnding
//
//  Created by KiWoong Hong on 2022/11/01.
//

import SwiftUI
import FirebaseCore
import FirebaseFirestore
import FirebaseFirestoreSwift
import FirebaseAuth

/*
    shortcutsZip 앱 내에서 각 뷰에 필요한 데이터를 전달하기위한 ViewModel Class 입니다.
    * 해당 class 내부에 있는 함수의 자세한(?) 설명은 MARK를 참조해주세요 *
 */

class ShortcutsZipViewModel: ObservableObject {
    
    @AppStorage("signInStatus") var signInStatus = false
    @AppStorage("shortcutGrade") var shortcutGrade = ShortcutGrade.level0.rawValue
    
    @Published var userInfo: User?                              // 유저정보
    
    @Published var shortcutsUserLiked: [Shortcuts] = []         // 유저가 좋아요한 숏컷들
    @Published var shortcutsUserDownloaded: [Shortcuts] = []    // 유저가 다운로드한 숏컷들
    @Published var shortcutsMadeByUser: [Shortcuts] = []        // 유저가 만든 숏컷배열
    @Published var sortedShortcutsByDownload: [Shortcuts] = []  // 다운로드 수에 의해 정렬된 숏컷
    @Published var sortedShortcutsByLike: [Shortcuts] = []      // 다운로드 수에 의해 정렬된 숏컷
    
    @Published var shortcutsInCategory: [[Shortcuts]] = [[Shortcuts]].init(repeating: [], count: Category.allCases.count) // Category에서 사용할 숏컷 배열
    
    @Published var curationsMadeByUser: [Curation] = []         // 유저가 만든 큐레이션배열
    @Published var userCurations: [Curation] = [] {
        didSet {
            self.refreshPersonalCurations()
        }
    }
    @Published var personalCurations: [Curation] = []           // "땡땡님을 위한 모음집" 큐레이션배열
    @Published var adminCurations: [Curation] = []
    
    @Published var allComments: [Comments] = []
    @Published var keywords: Keyword = Keyword(keyword: [String]())
    
    static let share = ShortcutsZipViewModel()
    private let db = Firestore.firestore()
    
    var allShortcuts: [Shortcuts] = []
    var userAuth = UserAuth.shared
    
    let numberOfPageLimit = 10
    let minimumOfLike = 5
    
    init() {
        fetchUser(userID: self.currentUser(), isCurrentUser: true) { user in
            self.userInfo = user
            self.initUserShortcut(user: user)
        }
        fetchShortcutAll { shortcuts in
            self.allShortcuts = shortcuts
            self.initShortcut()
        }
        fetchCuration(isAdmin: true) { curations in
            self.adminCurations = curations.sorted(by: { $0.dateTime > $1.dateTime })
        }
        fetchCuration(isAdmin: false) { curations in
            self.userCurations = curations.sorted(by: { $0.dateTime > $1.dateTime })
            self.curationsMadeByUser = self.fetchCurationByAuthor(author: self.currentUser())
            self.sortCuration()
        }
        fetchKeyword { keywords in
            self.keywords = keywords
        }
        fetchCommentAll { comments in
            self.allComments = comments
        }
    }
    
    func refreshPersonalCurations() {
        self.personalCurations.removeAll()
        let personalCurationIDs = Set(self.shortcutsUserDownloaded.flatMap({ $0.curationIDs }))
        for curationID in personalCurationIDs {
            if let curation = self.userCurations.first(where: { $0.id == curationID }) {
                if !Set(self.personalCurations).contains(curation) {
                    self.personalCurations.append(curation)
                }
            }
        }
    }
    
    func initUserShortcut(user: User) {
        shortcutsMadeByUser = allShortcuts.filter { $0.author == user.id }
        user.downloadedShortcuts.forEach({ downloadedShortcut in
            if let index = allShortcuts.firstIndex(where: {$0.id == downloadedShortcut.id}) {
                shortcutsUserDownloaded.append(allShortcuts[index])
            }
        })
        user.likedShortcuts.forEach({ shortcutID in
            if let index = allShortcuts.firstIndex(where: {$0.id == shortcutID}) {
                shortcutsUserLiked.append(allShortcuts[index])
            }
        })
        refreshPersonalCurations()
        shortcutGrade = checkShortcutGrade(userID: nil).rawValue
    }
    func initShortcut() {
        sortedShortcutsByDownload = allShortcuts.sorted(by: {$0.numberOfDownload > $1.numberOfDownload})
        sortedShortcutsByLike = allShortcuts.filter { $0.numberOfLike >= minimumOfLike }
        for category in Category.allCases {
            shortcutsInCategory[category.index] = allShortcuts.filter { $0.category.contains(category.rawValue) }
        }
    }
    
    
    //MARK: - 데이터를 받아오는 함수들
    
    //MARK: - 단축어
    
    func fetchShortcutAll(
        completionHandler: @escaping ([Shortcuts])->()) {
            
            var shortcuts: [Shortcuts] = []
            var query: Query!
            
            query = db.collection("Shortcut").order(by: "date", descending: false)
            
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
                        let shortcut = try decoder.decode(Shortcuts.self, from: jsonData)
                        
                        if (diff.type == .added) {
                            shortcuts.insert(shortcut, at: 0)
                            self.sortedShortcutsByDownload.append(shortcut)
                            shortcut.category.forEach { category in
                                self.shortcutsInCategory[Category(rawValue: category)!.index].insert(shortcut, at: 0)
                            }
                        }
                        if (diff.type == .modified) {
                            if let index = shortcuts.firstIndex(where: { $0.id == shortcut.id}) {
                                shortcuts[index] = shortcut
                            }
                            self.updateShortcutInList(shortcut: shortcut)
                        }
                        if (diff.type == .removed) {
                            shortcuts.removeAll(where: { $0.id == shortcut.id})
                            self.deleteShortcutInList(shortcut: shortcut)
                        }
                    } catch let error {
                        print("error: \(error)")
                    }
                }
                completionHandler(shortcuts)
            }
        }
    
    func updateShortcutInList(shortcut: Shortcuts) {
        if let index = self.allShortcuts.firstIndex(where: {$0.id == shortcut.id}) {
            self.allShortcuts[index] = shortcut
        }
        if let index = self.shortcutsUserLiked.firstIndex(where: { $0.id == shortcut.id}) {
            self.shortcutsUserLiked[index] = shortcut
        }
        if let index = self.shortcutsUserDownloaded.firstIndex(where: { $0.id == shortcut.id}) {
            self.shortcutsUserDownloaded[index] = shortcut
        }
        if let index = self.shortcutsMadeByUser.firstIndex(where: { $0.id == shortcut.id}) {
            self.shortcutsMadeByUser[index] = shortcut
        }
        if let index = self.sortedShortcutsByDownload.firstIndex(where: { $0.id == shortcut.id}) {
            self.sortedShortcutsByDownload[index] = shortcut
        }
        if shortcut.numberOfLike >= 5 {
            self.sortedShortcutsByLike.append(shortcut)
        }
    }
    
    func deleteShortcutInList(shortcut: Shortcuts) {
        self.allShortcuts.removeAll(where: {$0.id == shortcut.id})
        self.shortcutsUserLiked.removeAll(where: {$0.id == shortcut.id})
        self.shortcutsUserDownloaded.removeAll(where: {$0.id == shortcut.id})
        self.shortcutsMadeByUser.removeAll(where: {$0.id == shortcut.id})
        self.sortedShortcutsByDownload.removeAll(where: {$0.id == shortcut.id})
        self.sortedShortcutsByLike.removeAll(where: {$0.id == shortcut.id})
        shortcut.category.forEach { category in
            self.shortcutsInCategory[Category(rawValue: category)!.index].removeAll(where: { $0.id == shortcut.id })
        }
        deleteShortcutInCuration(curationsIDs: shortcut.curationIDs, shortcutID: shortcut.id)
    }
    
    //MARK: Shortcut의 세부 정보를 가져오는 함수
    
    func fetchShortcutDetail(id: String) -> Shortcuts? {
        if let index = allShortcuts.firstIndex(where: {$0.id == id}) {
            return allShortcuts[index]
        }
        return nil
    }
    
    //MARK: ReadShortcutView에서 해당 단축어에 좋아요를 눌렀는지 확인하는 함수 completionHandler로 bool값을 전달
    
    func checkLikedShortrcut(shortcutID: String) -> Bool {
        userInfo?.likedShortcuts.contains(shortcutID) ?? false
    }
    
    //MARK: 현재 사용자가 작성한 Shortcuts -> ShortcutCellModel 형태로 변환하여 가져오는 함수 -> 큐레이션 작성
    
    func fetchMadeShortcutCell() -> [ShortcutCellModel] {
        var shortcutCells: [ShortcutCellModel] = []
        
        for shortcut in shortcutsMadeByUser {
            let shortcutCell = ShortcutCellModel(
                id: shortcut.id,
                sfSymbol: shortcut.sfSymbol,
                color: shortcut.color,
                title: shortcut.title,
                subtitle: shortcut.subtitle,
                downloadLink: shortcut.downloadLink[0]
            )
            shortcutCells.append(shortcutCell)
        }
        return shortcutCells
    }
    
    // MARK: 현재 사용자가 좋아요한 Shortcuts -> ShortcutCellModel 형태로 변환 -> 큐레이션 작성
    
    func fetchLikedShortcutCell() -> [ShortcutCellModel] {
        var shortcutCells: [ShortcutCellModel] = []
        
        for shortcut in shortcutsUserLiked {
            let shortcutCell = ShortcutCellModel(
                id: shortcut.id,
                sfSymbol: shortcut.sfSymbol,
                color: shortcut.color,
                title: shortcut.title,
                subtitle: shortcut.subtitle,
                downloadLink: shortcut.downloadLink[0]
            )
            shortcutCells.append(shortcutCell)
        }
        return shortcutCells
    }
    
    //MARK: 큐레이션 작성 - 선택 가능한 단축어 리스트
    
    func fetchShortcutMakeCuration() -> [ShortcutCellModel] {
        var shortcutCells = Set<ShortcutCellModel>()
        
        for shortcut in shortcutsUserLiked {
            let shortcutCell = ShortcutCellModel(
                id: shortcut.id,
                sfSymbol: shortcut.sfSymbol,
                color: shortcut.color,
                title: shortcut.title,
                subtitle: shortcut.subtitle,
                downloadLink: shortcut.downloadLink[0]
            )
            shortcutCells.insert(shortcutCell)
        }
        
        for shortcut in shortcutsMadeByUser {
            let shortcutCell = ShortcutCellModel(
                id: shortcut.id,
                sfSymbol: shortcut.sfSymbol,
                color: shortcut.color,
                title: shortcut.title,
                subtitle: shortcut.subtitle,
                downloadLink: shortcut.downloadLink[0]
            )
            shortcutCells.insert(shortcutCell)
        }
        
        return Array(shortcutCells)
    }
    
    //MARK: 단축어 버전 업데이트하는 함수
    
    func updateShortcutVersion(shortcut: Shortcuts, updateDescription: String, updateLink: String) {
        var data = shortcut
        //서버 - 단축어 업데이트
        data.downloadLink.insert(updateLink, at: 0)
        data.updateDescription.insert(updateDescription, at: 0)
        data.date.insert(Date().getDate(), at: 0)
        
        if let index = allShortcuts.firstIndex(where: {$0.id == shortcut.id}) {
            allShortcuts[index] = data
        }
        //카테고리별 단축어
        shortcut.category.forEach { category in
            if let index = shortcutsInCategory[Category(rawValue: category)!.index].firstIndex(where: { $0.id == shortcut.id}) {
                shortcutsInCategory[Category(rawValue: category)!.index][index] = shortcut
            }
        }
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
    }
    
    //MARK: - 큐레이션
    
    //MARK: 추천모음집 단축어 순서 정렬 함수
    func sortCuration() {
        for index in 0..<userCurations.count {
            userCurations[index].shortcuts = userCurations[index].shortcuts.sorted{ $0.title < $1.title}
        }
    }
    
    //MARK: Curation을 (admin, user) 구분하여 가져오는 함수
    
    func fetchCuration(isAdmin: Bool, completionHandler: @escaping ([Curation])->()) {
        var curations: [Curation] = []
        
        var query: Query!
        
        query = db.collection("Curation")
            .whereField("isAdmin", isEqualTo: isAdmin)
        
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
                        self.curationsMadeByUser.insert(curation, at: 0)
                        self.userCurations.insert(curation, at: 0)
                    }
                    if (diff.type == .modified) {
                        if let index = curations.firstIndex(where: { $0.id == curation.id}) {
                            curations[index] = curation
                        }
                        if let index = self.curationsMadeByUser.firstIndex(where: { $0.id == curation.id}) {
                            self.curationsMadeByUser[index] = curation
                        }
                        if let index = self.adminCurations.firstIndex(where: { $0.id == curation.id}) {
                            self.adminCurations[index] = curation
                        }
                        if let index = self.userCurations.firstIndex(where: { $0.id == curation.id}) {
                            self.userCurations[index] = curation
                        }
                    }
                    if (diff.type == .removed) {
                        curations.removeAll(where: { $0.id == curation.id})
                    }
                } catch let error {
                    print("error: \(error)")
                }
            }
            completionHandler(curations)
        }
    }
    
    // MARK: Author에 의한 큐레이션들 받아오는 함수 (나의 큐레이션)
    
    func fetchCurationByAuthor(author: String) -> [Curation] {
        userCurations.filter { $0.author == author }
    }
    
    //MARK: id값으로 큐레이션 정보를 받아오는 함수
    
    func fetchCurationDetail(curationID: String) -> Curation? {
        if let index = userCurations.firstIndex(where: {$0.id == curationID}) {
            return userCurations[index]
        }
        return nil
    }
    
    //MARK: 유저와 관련된 큐레이션을 가져오는 함수
    
    func fetchUserRelatedCuration() -> [Curation] {
        var relatedCurations = Set<Curation>()
        
        if let userInfo = self.userInfo {
            let downloadedShortcut = userInfo.downloadedShortcuts
            for shortcut in downloadedShortcut {
                if let curationIDs = fetchShortcutDetail(id: shortcut.id)?.curationIDs {
                    for curationID in curationIDs {
                        if let relatedCuration = fetchCurationDetail(curationID: curationID) {
                            relatedCurations.insert(relatedCuration)
                        }
                    }
                }
            }
        }
        return Array(relatedCurations)
    }
}
    
//MARK: - 저장, 편집 관련 함수
extension ShortcutsZipViewModel {
    //TODO: Error 처리 필요
    
    func setData(model: Any) {
        switch model {
        case _ as Shortcuts:
            db.collection("Shortcut").document((model as! Shortcuts).id).setData((model as! Shortcuts).dictionary)
        case _ as Curation:
            db.collection("Curation").document((model as! Curation).id).setData((model as! Curation).dictionary)
        case _ as User:
            db.collection("User").document((model as! User).id).setData((model as! User).dictionary)
        case _ as Comments:
            db.collection("Comment").document((model as! Comments).id).setData((model as! Comments).dictionary)
        case _ as SuggestionForm:
            db.collection("SuggestionForm").document((model as! SuggestionForm).id).setData((model as! SuggestionForm).dictionary)
        default:
            print("this is not a model.")
        }
    }
    
    //MARK: 단축어 수정 시 단축어 업데이트하는 함수
    func updateShortcut(existingCategory: [String], newCategory: [String], shortcut: Shortcuts) {
        var newCategory = newCategory
        existingCategory.forEach { category in
            if !shortcut.category.contains(category) {
                newCategory.removeAll(where: { $0 == category })
                self.shortcutsInCategory[Category(rawValue: category)!.index].removeAll(where: { $0.id == shortcut.id })
            } else {
                newCategory.removeAll(where: { $0 == category })
                if let index = self.shortcutsInCategory[Category(rawValue: category)!.index].firstIndex(where: { $0.id == shortcut.id}) {
                    self.shortcutsInCategory[Category(rawValue: category)!.index][index] = shortcut
                }
            }
        }
        
        //TODO: 셀정보에 변경사항이 있을 경우에만 함수를 호출하도록 변경 필요
        self.updateShortcutInCuration(
            shortcutCell: ShortcutCellModel(
                id: shortcut.id,
                sfSymbol: shortcut.sfSymbol,
                color: shortcut.color,
                title: shortcut.title,
                subtitle: shortcut.subtitle,
                downloadLink: shortcut.downloadLink.last!
            ),
            curationIDs: shortcut.curationIDs
        )
    }
    //MARK: 단축어 수정 시 해당 단축어가 포함된 큐레이션 서버 데이터를 업데이트하는 함수 -> 단축어 정보 업데이트
    
    func updateShortcutInCuration(shortcutCell: ShortcutCellModel, curationIDs: [String]) {
        for curationID in curationIDs {
            if let index = userCurations.firstIndex(where: { $0.id == curationID}) {
                var updateCuration = userCurations[index]
                if let shortcutIndex = updateCuration.shortcuts.firstIndex(where: { $0.id == shortcutCell.id }) {
                    updateCuration.shortcuts[shortcutIndex] = shortcutCell
                    self.setData(model: updateCuration)
                }
            }
        }
    }
    
    //MARK: 좋아요 수를 업데이트하는 함수
    
    func updateNumberOfLike(isMyLike: Bool, shortcut: Shortcuts) {
        var increment = 0
        if isMyLike {
            increment = 1
            shortcutsUserLiked.append(shortcut)
            userInfo?.likedShortcuts.append(shortcut.id)
            self.fetchUser(userID: self.currentUser(), isCurrentUser: true) { data in
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
            shortcutsUserLiked.removeAll(where: { $0.id == shortcut.id })
            userInfo?.likedShortcuts.removeAll(where: { $0 == shortcut.id })
            self.fetchUser(userID: self.currentUser(), isCurrentUser: true) { data in
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
    
    /**
     서버 단축어 다운로드 숫자 업데이트,
     서버 유저 - downlodedShortcuts 정보 수정
     뷰모델 유저 - downlodedShortcuts 정보 수정
     */
    func updateNumberOfDownload(shortcut: Shortcuts, downloadlinkIndex: Int) {
        if var user = self.userInfo {
            if let index = user.downloadedShortcuts.firstIndex(where: { $0.id == shortcut.id }) {
                //유저 정보
                if downloadlinkIndex == 0 && user.downloadedShortcuts[index].downloadLink != shortcut.downloadLink[0] {
                    user.downloadedShortcuts[index].downloadLink = shortcut.downloadLink[0] //서버 전송용
                    self.userInfo?.downloadedShortcuts[index].downloadLink = shortcut.downloadLink[0] //뷰모델 변경용
                    self.setData(model: user)
                    //단축어 정보
                    if let shortcutListIndex = self.shortcutsUserDownloaded.firstIndex(where: {$0.id == shortcut.id}) {
                        shortcutsUserDownloaded[shortcutListIndex] = shortcut
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
                //유저 정보
                let shortcutInfo = DownloadedShortcut(
                    id: shortcut.id,
                    downloadLink: shortcut.downloadLink[downloadlinkIndex])
                user.downloadedShortcuts.append(shortcutInfo) // 서버 전송용
                self.userInfo?.downloadedShortcuts.append(shortcutInfo) //뷰모델 변경용
                self.setData(model: user)
                //단축어 정보
                self.shortcutsUserDownloaded.insert(shortcut, at: 0)
            }
        }
        self.refreshPersonalCurations()
    }
    
    //MARK: 큐레이션 생성 시 포함된 단축어에 큐레이션 아이디를 저장하는 함수
    
    func updateShortcutCurationID (shortcutCells: [ShortcutCellModel], curationID: String, isEdit: Bool, deletedShortcutCells: [ShortcutCellModel]?) {
        if isEdit {
            deletedShortcutCells!.forEach { shortcutCell in
                if var shortcut = fetchShortcutDetail(id: shortcutCell.id) {
                    shortcut.curationIDs.removeAll(where: { $0 == curationID})
                    self.setData(model: shortcut)
                }
            }
        }
        shortcutCells.forEach { shortcutCell in
            if var shortcut = fetchShortcutDetail(id: shortcutCell.id) {
                if !shortcut.curationIDs.contains(curationID) {
                    shortcut.curationIDs.append(curationID)
                    self.setData(model: shortcut)
                }
            }
        }
    }
    
    //MARK: 새로운 큐레이션 추가하는 함수
    func addCuration(curation: Curation, isEdit: Bool, deletedShortcutCells: [ShortcutCellModel]) {
        var curation = curation
        var deletedShortcutCells = deletedShortcutCells
        
        if isEdit {
            curation.shortcuts.forEach { shortcutCell in
                deletedShortcutCells.removeAll(where: { $0.id == shortcutCell.id })
            }
        }
        
        curation.shortcuts = curation.shortcuts.sorted { $0.title < $1.title }
        curation.author = currentUser()
        setData(model: curation)
        updateShortcutCurationID(
            shortcutCells: curation.shortcuts,
            curationID: curation.id,
            isEdit: isEdit,
            deletedShortcutCells: deletedShortcutCells
        )
        if let index = userCurations.firstIndex(where: { $0.id == curation.id }) {
            userCurations[index] = curation
        }
    }
}
    
//MARK: - 삭제 관련 함수
extension ShortcutsZipViewModel {
    //TODO: Error 처리 필요
    
    func deleteData(model: Any) {
        switch model {
        case _ as Shortcuts:
            db.collection("Shortcut").document((model as! Shortcuts).id).delete()
        case _ as Curation:
            db.collection("Curation").document((model as! Curation).id).delete()
        case _ as User:
            db.collection("User").document((model as! User).id).delete()
        case _ as Comments:
            db.collection("Comment").document((model as! Comments).id).delete()
        default:
            print("this is not a model.")
        }
    }
    
    func deleteUserData(userID: String) {
        db.collection("User").document(userID).delete() { err in
            if let err = err {
                print("Error removing document: \(err)")
            } else {
                print("Document successfully removed!")
                self.resetUser()
                
                let firebaseAuth = Auth.auth()
                let currentUser = firebaseAuth.currentUser
                currentUser?.delete { error in
                    if let error {
                        print("\(error.localizedDescription)")
                    } else {
                        withAnimation(.easeInOut) {
                            self.signInStatus = false
                            self.userAuth.signOut()
                        }
                    }
                }
            }
        }
    }
    
    //MARK: 단축어 삭제 시 유저 정보에 포함된 id 삭제하는 함수
    
    func deleteShortcutIDInUser(shortcutID: String) {
        self.userInfo?.likedShortcuts.removeAll(where: { $0 == shortcutID })
        self.userInfo?.downloadedShortcuts.removeAll(where: { $0.id == shortcutID })
        self.setData(model: userInfo!)
    }
    
    //MARK: 단축어 삭제 시 해당 단축어를 포함하는 큐레이션에서 삭제하는 함수
    
    func deleteShortcutInCuration(curationsIDs: [String], shortcutID: String) {
        curationsIDs.forEach { curationID in
            if var curation = fetchCurationDetail(curationID: curationID) {
                curation.shortcuts.removeAll(where: { $0.id == shortcutID })
                self.setData(model: curation)
            }
        }
    }
    
    //MARK: 큐레이션 삭제 시 단축어에서 curationID를 삭제하는 함수
    
    func deleteCurationIDInShortcut(curationID: String) {
        let shortcutsContainsCuration = allShortcuts.filter { $0.curationIDs.contains(curationID) }
        shortcutsContainsCuration.forEach { data in
            var shortcut = data
            shortcut.curationIDs.removeAll(where: {$0 == curationID})
            self.setData(model: shortcut)
        }
    }
    
}

//MARK: - 유저 관련 함수
extension ShortcutsZipViewModel {
    
    //MARK: 로그인 정보 제거
    
    func resetUser() {
        self.userInfo = nil
        self.shortcutsMadeByUser.removeAll()
        self.curationsMadeByUser.removeAll()
        self.shortcutsUserDownloaded.removeAll()
        self.shortcutsUserLiked.removeAll()
        UserDefaults.shared.set(nil, forKey: "ShareUserInfo")
    }
    
    // MARK: 현재 로그인한 아이디 리턴
    
    func currentUser() -> String {
        UserDefaults.shared.set(Auth.auth().currentUser?.uid, forKey: "ShareUserInfo")
        return Auth.auth().currentUser?.uid ?? ""
    }
    
    //MARK: 로그인한 아이디로 User 가져오는 함수
    
    func fetchUser(userID: String, isCurrentUser: Bool, completionHandler: @escaping (User)->()) {
        
        db.collection("User")
            .whereField("id", isEqualTo: userID)
            .getDocuments { (querySnapshot, error) in
                if let error {
                    print("Error getting documents: \(error)")
                } else {
                    guard let documents = querySnapshot?.documents else { return }
                    if documents.isEmpty && isCurrentUser {
                        withAnimation(.easeInOut) {
                            self.signInStatus = false
                        }
                    }
                    let decoder = JSONDecoder()
                    for document in documents {
                        do {
                            let data = document.data()
                            let jsonData = try JSONSerialization.data(withJSONObject: data)
                            let user = try decoder.decode(User.self, from: jsonData)
                            completionHandler(user)
                        } catch let error {
                            withAnimation(.easeInOut) {
                                self.signInStatus = true
                            }
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
}

// MARK: - 검색 관련 함수
extension ShortcutsZipViewModel {
    
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
                completionHandler(shortcuts)
            }
        }
    }
    
    //MARK: 키워드 받아오는 함수
    func fetchKeyword(completionHandler: @escaping (Keyword)->()) {
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
}

//MARK: - 댓글 관련 함수
extension ShortcutsZipViewModel {
    //MARK: 모든 댓글을 가져오는 함수
    
    func fetchCommentAll(completionHandler: @escaping ([Comments]) -> ()) {
        var comments: [Comments] = []
        var query: Query!
        
        query = db.collection("Comment")
        
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
                    let comment = try decoder.decode(Comments.self, from: jsonData)
                    
                    if (diff.type == .added) {
                        comments.insert(comment, at: 0)
                    }
                    if (diff.type == .modified) {
                        if let index = comments.firstIndex(where: {$0.id == comment.id}) {
                            comments[index] = comment
                        }
                    }
                    if (diff.type == .removed) {
                        comments.removeAll(where: { $0.id == comment.id})
                    }
                } catch let error {
                    print("error: \(error)")
                }
            }
            completionHandler(comments)
        }
    }
    
    //MARK: 단축어 ID에 해당하는 댓글 목록 불러오는 함수
    
    func fetchComment(shortcutID: String) -> Comments {
        if let index = allComments.firstIndex(where: {$0.id == shortcutID}) {
            var allComments = self.allComments[index]
            allComments.comments = allComments.fetchSortedComment()
            return allComments
        }
        return Comments(id: shortcutID, comments: [])
    }
    
    func updateComment(shortcutID: String, comment: Comment) {
        var data = comment
        data.date = Date().getDate()
        data.user_id = self.userInfo!.id
        var comments = fetchComment(shortcutID: shortcutID)
        comments.comments.append(data)
        setData(model: comments)
    }
    
    //대댓글 삭제 시 이용
    func deleteComment(shortcutID: String, commentID: String) {
        var comments = fetchComment(shortcutID: shortcutID)
        comments.comments.removeAll(where: { $0.id == commentID })
        setData(model: comments)
    }
    
    //원댓글 삭제 시 이용
    func deleteCommentByBundleID(shortcutID: String, bundleID: String) {
        var comments = fetchComment(shortcutID: shortcutID)
        comments.comments.removeAll(where: { $0.bundle_id == bundleID })
        setData(model: comments)
    }
}

//MARK: - 등급 관련 함수
extension ShortcutsZipViewModel {
    
    func checkShortcutGrade(userID: String?) -> ShortcutGrade {
        var count = 0
        
        if let userID {
            count = allShortcuts.filter { $0.author == userID }.count
        } else {
            count = shortcutsMadeByUser.count
        }
        
        switch count {
        case ..<1:
            return .level0
        case 1..<5:
            return .level1
        case 5..<10:
            return .level2
        case 10..<25:
            return .level3
        case 25..<50:
            return .level4
        default:
            return .level5
        }
    }
    
    func countShortcutsToNextGrade(numberOfShortcuts: Int) -> Int {
        switch numberOfShortcuts {
        case 0..<1:
            return 1
        case 1..<5:
            return 5-numberOfShortcuts
        case 5..<10:
            return 10-numberOfShortcuts
        case 10..<25:
            return 25-numberOfShortcuts
        case 25..<50:
            return 50-numberOfShortcuts
        default:
            return 0
        }
    }
    
    func fetchShortcutGradeImage(isBig: Bool, shortcutGrade: ShortcutGrade) -> Image {
        switch shortcutGrade {
        case .level0:
            return Image("profileIcon")
        case .level1:
            return Image(isBig ? "level1Big" : "level1Small")
        case .level2:
            return Image(isBig ? "level5Big" : "level5Small")
        case .level3:
            return Image(isBig ? "level10Big" : "level10Small")
        case .level4:
            return Image(isBig ? "level25Big" : "level25Small")
        case .level5:
            return Image(isBig ? "level50Big" : "level50Small")
        }
    }
    
    func fetchShortcutGradeSuperImage(shortcutGrade: ShortcutGrade) -> Image {
        switch shortcutGrade {
        case .level0:
            return Image(systemName: "person.crop.circle.fill")
        case .level1:
            return Image("level1Super")
        case .level2:
            return Image("level5Super")
        case .level3:
            return Image("level10Super")
        case .level4:
            return Image("level25Super")
        case .level5:
            return Image("level50Super")
        }
    }
    
    func isShortcutUpgrade() -> Bool {
        let currentGrade = checkShortcutGrade(userID: nil).rawValue
        
        if shortcutGrade < currentGrade {
            shortcutGrade = currentGrade
            return true
        } else {
            return false
        }
    }
    
    func isShortcutDowngrade() -> Bool {
        [1, 5, 10, 25, 50].contains(shortcutsMadeByUser.count)
    }
    
    func updateShortcutGrade() {
        shortcutGrade = checkShortcutGrade(userID: nil).rawValue
    }
}
