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
    
    @State var keywords: Keyword = Keyword(keyword: [String]())
    @State var isSearched: Bool = false
    @State var searchText: String = ""
    @State var shortcutResults = Set<Shortcuts>()
    
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
        .onAppear() {
            self.keywords = shortcutsZipViewModel.keywords
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
        .background(Color.Background)
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
                .padding(.top, 12)
                .Headline()
            
            ScrollView(.horizontal) {
                HStack {
                    ForEach(keywords.keyword, id: \.self) { keyword in
                        Text(keyword)
                            .Body2()
                            .foregroundColor(Color.Gray4)
                            .padding(.horizontal, 12)
                            .padding(.vertical, 8)
                            .overlay(
                                RoundedRectangle(cornerRadius: 12)
                                    .strokeBorder(Color.Gray4, lineWidth: 1)
                            )
                            .onTapGesture {
                                searchText = keyword
                                runSearch()
                            }
                    }
                }
                .padding(.leading, 16)
                .padding(.top, 8)
            }
        }
    }
    
    var proposeView: some View {
        VStack(alignment: .center) {
            Text("\(searchText)의 결과가 없어요.\n원하는 단축어를 제안해보는건 어떠세요?").multilineTextAlignment(.center)
                .Body1()
                .foregroundColor(Color.Gray4)
            
            Button {
                //TODO: 버튼 클릭 시 단축어 제안하는 페이지 연결
            } label: {
                Text("단축어 제안하기")
                    .padding(.horizontal, 28)
                    .padding(.vertical, 8)
            }.buttonStyle(.borderedProminent)
                .padding(16)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color.Background)
    }
}

struct SearchView_Previews: PreviewProvider {
    static var previews: some View {
        SearchView()
    }
}
