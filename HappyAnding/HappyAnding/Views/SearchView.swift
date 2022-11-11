//
//  SearchView.swift
//  HappyAnding
//
//  Created by 이지원 on 2022/11/09.
//

import SwiftUI

struct SearchView: View {
    
    @EnvironmentObject var shorcutsZipViewModel: ShortcutsZipViewModel
    @State var searchText: String = ""
    
    let result = ["result1", "result2", "ressult3"]
    
    @State var shortcutResults = Set<Shortcuts>()
    @State var results = [Shortcuts]()
    
    var body: some View {
        VStack {
            searchBar
            searchResultList
        }
    }
    
    
    // MARK: - 검색 바
    
    var searchBar: some View {
        HStack {
            Image(systemName: "magnifyingglass")
            
            TextField("단축어 이름, 앱 이름으로 검색해보세요", text: $searchText)
                .onSubmit {
                    // TODO: Firebase 함수 연결
                    shortcutResults.removeAll()
                    self.shorcutsZipViewModel.searchShortcutByRequiredApp(word: searchText) { shortcuts in
                        shortcuts.forEach { shortcut in
                            shortcutResults.insert(shortcut)
                        }
                    }
                    self.shorcutsZipViewModel.searchShortcutByTitlePrefix(keyword: searchText) { shortcuts in
                        shortcuts.forEach { shortcut in
                            shortcutResults.insert(shortcut)
                        }
                    }
                }
            
            if !searchText.isEmpty {
                Image(systemName: "xmark.circle.fill")
                    .onTapGesture {
                        withAnimation {
                            self.searchText = ""
                        }
                    }
            }
            
        }
        .padding(.horizontal, 16)
    }
    
    
    // MARK: - 검색 결과
    var searchResultList: some View {
        
        List {
            ForEach( shortcutResults.sorted(by: { $0.title < $1.title}), id: \.self) { shortcut in
                ShortcutCell(shortcut: shortcut)
            }
        }
    }
    
}

struct SearchView_Previews: PreviewProvider {
    static var previews: some View {
        SearchView()
    }
}
