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
    
    @FocusState private var isFocused: Bool
    
    @State var keywords: Keyword = Keyword(keyword: [String]())
    @State var isSearched: Bool = false
    @State var searchText: String = ""
    @State var shortcutResults = Set<Shortcuts>()
    
    
    var body: some View {
        VStack {
            
            searchTextfield
            
            if !isSearched {
                recommendKeyword
                Spacer()
            } else {
                if shortcutResults.count == 0 {
                    proposeView
                } else {
                    ScrollView {
                        VStack(spacing: 0) {
                            ForEach(shortcutResults.sorted(by: { $0.title < $1.title }), id: \.self) { shortcut in
                                
                                let data = NavigationReadShortcutType(shortcutID: shortcut.id,
                                                                      navigationParentView: .shortcuts)
                                
                                ShortcutCell(shortcut: shortcut,
                                             navigationParentView: NavigationParentView.shortcuts)
                                .navigationLinkRouter(data: data)
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
        .onSubmit(of: .search, runSearch)
        .onChange(of: searchText) { _ in
            didChangedSearchText()
            if !searchText.isEmpty {
                isSearched = true
            } else if searchText.isEmpty && !isSearching {
                shortcutResults.removeAll()
                isSearched = false
            }
        }
        .navigationBarTitleDisplayMode(.inline)
        .background(Color.shortcutsZipBackground)
        .navigationBarBackground ({ Color.shortcutsZipBackground })
    }
    
    private func runSearch() {
        isSearched = true
    }
    
    var searchTextfield: some View {
        HStack(alignment: .center, spacing: 8) {
            HStack {
                Image(systemName: "magnifyingglass")
                    .foregroundColor(.gray5)
                TextField(TextLiteral.searchViewPrompt, text: $searchText)
                    .shortcutsZipBody1()
                    .accentColor(.gray5)
                    .disableAutocorrection(true)
                    .onChange(of: searchText) { _ in
                        // TODO: 수정 필요
                        didChangedSearchText()
                    }
                    .focused($isFocused)
                    .task {
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                            isFocused = true
                        }
                    }
                    .shortcutsZipBody1()
            }
            .padding(11)
            .background(Color.gray1)
            .cornerRadius(12)
        }
        .padding(EdgeInsets(top: 12, leading: 16, bottom: 20, trailing: 16))
    }
    
    var recommendKeyword: some View {
        VStack(alignment: .leading) {
            Text(TextLiteral.searchViewRecommendedKeyword)
                .padding(.leading, 16)
                .shortcutsZipHeadline()
            
            ScrollView(.horizontal) {
                HStack {
                    ForEach(keywords.keyword, id: \.self) { keyword in
                        Text(keyword)
                            .shortcutsZipBody2()
                            .foregroundColor(Color.gray4)
                            .padding(.horizontal, 12)
                            .padding(.vertical, 8)
                            .overlay(
                                RoundedRectangle(cornerRadius: 12)
                                    .strokeBorder(Color.gray4, lineWidth: 1)
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
            Text("\'\(searchText)\'의 결과가 없어요.\n원하는 단축어가 있다면 제안해보세요!").multilineTextAlignment(.center)
                .shortcutsZipBody1()
                .foregroundColor(Color.gray4)
            
            Link(destination: URL(string: TextLiteral.searchViewProposalURL)!) {
                Text(TextLiteral.searchViewProposal)
                    .padding(.horizontal, 28)
                    .padding(.vertical, 8)
            }
            .buttonStyle(.borderedProminent)
            .padding(16)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color.shortcutsZipBackground)
    }
    private func didChangedSearchText() {
        shortcutResults.removeAll()
        
        for data in shortcutsZipViewModel.allShortcuts {
            if data.title.lowercased().contains(searchText.lowercased()) ||
                !data.requiredApp.filter({ $0.lowercased().contains(searchText.lowercased()) }).isEmpty ||
                data.subtitle.lowercased().contains(searchText.lowercased())
            {
                shortcutResults.insert(data)
            }
        }
    }
}

struct SearchView_Previews: PreviewProvider {
    static var previews: some View {
        SearchView()
    }
}
