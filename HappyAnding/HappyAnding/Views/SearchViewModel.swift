//
//  SearchViewModel.swift
//  HappyAnding
//
//  Created by JeonJimin on 4/10/24.
//

import SwiftUI

final class SearchViewModel: ObservableObject {
    private let shortcutsZipViewModel = ShortcutsZipViewModel.share
    
    @Published var shortcutResults = [Shortcuts]()
    @Published var postResults:[[String]] = []
    @Published var keywords: Keyword = Keyword(keyword: ["아이스크림이 녹는 시간 계산", "빠르게 낙서하기", "볼륨 아주 작게 줄이기"])
    @Published var isSearched: Bool = false
    @Published var searchText: String = ""
    
    @Published var searchHistory: [String] = []
    
    init() {
        fetchSearchHistory()
    }
    
    private func fetchSearchHistory() {
        let history = UserDefaults.standard.array(forKey: "searchHistory")
        
        history?.forEach{ item in
            searchHistory.append(item as! String)
        }
    }
    
    func selectKeyword(index: Int) {
        searchText = keywords.keyword[index]
        addSearchHistory(text: searchText)
    }
    
    func addSearchHistory(text: String) {
        searchHistory.append(text)
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
