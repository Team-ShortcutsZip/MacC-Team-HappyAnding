//
//  SearchViewModel.swift
//  HappyAnding
//
//  Created by JeonJimin on 4/10/24.
//

import SwiftUI

//TODO: 레포지터리 머지 시 삭제 필요
//enum PostType: String, Codable {
//    case General = "General"
//    case Question = "Question"
//}
//
//struct Post: Identifiable, Codable, Equatable, Hashable {
//    
//    let id : String
//    let type: PostType
//    let createdAt: String
//    let author: String
//    
//    var content: String
//    var shortcuts: [String]
//    var images: [String]
//    var likedBy: [String:Bool]
//    var likeCount: Int
//    var commentCount: Int
//    
//    init(type: PostType, content: String, author: String, shortcuts: [String] = [], images: [String] = []) {
//        
//        self.id = UUID().uuidString
//        self.createdAt = Date().getDate()
//        
//        self.type = type
//        self.content = content
//        self.author = author
//        self.shortcuts = shortcuts
//        self.images = images
//        
//        self.likeCount = 0
//        self.commentCount = 0
//        self.likedBy = [:]
//        
//    }
//    
//    init() {
//        self.id = UUID().uuidString
//        self.createdAt = Date().getDate()
//        
//        self.type = .General
//        self.content = "가나다라마바사아자차카타파하가나다라마바사아자차카타파하가나다라마바사아자차카타파하가나다라마바사아자차카타파하가나다라마바사아자차카타파하가나다라마바사아자차카타파하"
//        self.author = "author"
//        self.shortcuts = ["shortcuts"]
//        self.images = ["images"]
//        
//        self.likeCount = 0
//        self.commentCount = 0
//        self.likedBy = [:]
//    }
//    
//    var dictionary: [String: Any] {
//        let data = (try? JSONEncoder().encode(self)) ?? Data()
//        return (try? JSONSerialization.jsonObject(with: data, options: .mutableContainers) as? [String: Any]) ?? [:]
//    }
//}

final class SearchViewModel: ObservableObject {
    private let shortcutsZipViewModel = ShortcutsZipViewModel.share
    
    @Published var shortcutResults = [Shortcuts]()
    @Published var postResults:[Post] = []
    @Published var keywords: Keyword = Keyword(keyword: ["아이스크림이 녹는 시간 계산", "빠르게 낙서하기", "볼륨 아주 작게 줄이기"])
    @Published var isSearched: Bool = false
    @Published var searchText: String = ""
    @Published var searchHistory: [String] = []
    
    let maxItemNum = 2
    
    init() {
        fetchSearchHistory()
    }
    
    private func fetchSearchHistory() {
        let history = UserDefaults.standard.array(forKey: "searchHistory")
        
        history?.forEach{ item in
            searchHistory.append(item as! String)
        }
    }
    
    func addSearchHistory(text: String) {
        searchHistory.insert(text, at: 0)
        if searchHistory.count > 5 {
            searchHistory.removeLast()
        }
        UserDefaults.standard.set(searchHistory, forKey: "searchHistory")
    }
    
    func removeSearchHistory(index: Int) {
        searchHistory.remove(at: index)
        UserDefaults.standard.set(searchHistory, forKey: "searchHistory")
    }
    
    func didChangedSearchText() {
        shortcutResults.removeAll()
        
        for data in shortcutsZipViewModel.allShortcuts {
            if data.title.lowercased().contains(searchText.lowercased()) ||
                !data.requiredApp.filter({ $0.lowercased().contains(searchText.lowercased()) }).isEmpty ||
                data.subtitle.lowercased().contains(searchText.lowercased())
            {
                shortcutResults.append(data)
            }
        }
    }
}
