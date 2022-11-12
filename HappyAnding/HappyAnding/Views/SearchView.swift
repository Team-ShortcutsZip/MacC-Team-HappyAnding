//
//  SearchView.swift
//  HappyAnding
//
//  Created by 이지원 on 2022/11/09.
//

import MessageUI
import SwiftUI

struct SearchView: View {
    @Environment(\.isSearching) private var isSearching: Bool
    @Environment(\.dismissSearch) private var dismissSearch
    @EnvironmentObject var shortcutsZipViewModel: ShortcutsZipViewModel
    
    @State var isSearched: Bool = false
    @State var searchText: String = ""
    @State var shortcutResults = Set<Shortcuts>()
    
    let keywords: [String] = ["단축어", "갓생", "포항꿀주먹"]
    
    var body: some View {
        VStack {
            if !isSearched {
                recommendKeword
                Spacer()
            } else {
                if shortcutResults.count == 0 {
                    proposeView
                } else {
                    ScrollView {
                        ForEach(shortcutResults.sorted(by: { $0.title < $1.title }), id: \.self) { result in
                            NavigationLink(destination: ReadShortcutView(shortcutID: result.id)) {
                                ShortcutCell(shortcut: result)
                                    .listRowInsets(EdgeInsets())
                                    .listRowSeparator(.hidden)
                            }
                        }
                    }
               }
            }
        }
        .searchable(text: $searchText)
        .onSubmit(of: .search, runSearch)
        .onChange(of: searchText) { value in
            if searchText.isEmpty && !isSearching {
                // Search cancelled here
                print("canceled")
                shortcutResults.removeAll()
                isSearched = false
            }
        }        .navigationBarTitleDisplayMode(.inline)
    }
    
    private func runSearch() {
        Task {
            isSearched = true
            shortcutsZipViewModel.searchShortcutByRequiredApp(word: searchText) { shortcuts in
                shortcuts.forEach { shortcut in
                    shortcutResults.insert(shortcut)
                }
            }
            shortcutsZipViewModel.searchShortcutByTitlePrefix(keyword: searchText) { shortcuts in
                shortcuts.forEach { shortcut in
                    shortcutResults.insert(shortcut)
                }
            }
        }
    }
    
    var recommendKeword: some View {
        VStack(alignment: .leading) {
            Text("추천 검색어")
                .padding(.leading, 16)
            
            ScrollView(.horizontal) {
                HStack {
                    // TODO: 선택된 텍스트 검색하는 기능
                    ForEach(keywords, id: \.self) { keyword in
                        Text(keyword)
                            .Body2()
                            .foregroundColor(Color.Gray4)
                            .padding(10)
                            .overlay(
                                RoundedRectangle(cornerRadius: 12)
                                    .stroke(Color.Gray4, lineWidth: 1)
                            )
                            .onTapGesture {
                                searchText = keyword
                                runSearch()
                            }
                    }
                }
                .padding(.leading, 16)
            }
        }
    }
    
    
    
    var proposeView: some View {
        VStack(alignment: .center) {
            Text("\(searchText)의 결과가 없어요.\n원하는 단축어를 제안해보는건 어떠세요?").multilineTextAlignment(.center)
                .Body1()
                .foregroundColor(Color.Gray4)
            
            Button {
                
            } label: {
                Text("단축어 제안하기")
                    .padding(.horizontal, 30)
                    .padding(.vertical, 8)
            }.buttonStyle(.borderedProminent)
                .padding(16)
        }
    }
}

struct CheckSearchView<Content: View>: View {
    @Environment(\.isSearching) var isSearching
    let content: (Bool) -> Content

    var body: some View {
        content(isSearching)
    }

    init(@ViewBuilder content: @escaping (Bool) -> Content) {
        self.content = content
    }
}

struct SearchView_Previews: PreviewProvider {
    static var previews: some View {
        SearchView()
    }
}
