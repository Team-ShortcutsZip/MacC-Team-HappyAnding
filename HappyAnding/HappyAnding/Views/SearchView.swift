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
    
    @State var isSearched: Bool = false
    @State var searchText: String = ""
    @State var searchResults: [Shortcuts] = []
    
    let keywords: [String] = ["단축어", "갓생", "포항꿀주먹"]
    
    var body: some View {
        VStack {
            if !isSearched {
                recommendKeword
                Spacer()
            } else {
                if searchResults.count == 0 {
                    proposeView
                } else {
                    ScrollView {
                        ForEach(searchResults, id: \.self) { result in
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
                searchResults.removeAll()
                isSearched = false
            }
        }        .navigationBarTitleDisplayMode(.inline)
        .background(Color.Background)
    }
    
    private func runSearch() {
        Task {
            isSearched = true
            // firebase 검색 기능 추가해서 searchResults에 넣기
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
                    }
                }
                .padding(.leading, 12)
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
