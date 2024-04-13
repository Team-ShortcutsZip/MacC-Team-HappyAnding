//
//  SearchView.swift
//  HappyAnding
//
//  Created by 이지원 on 2022/11/09.
//

import MessageUI
import SwiftUI

//TODO: 머지 전 화면 연결 필요
///검색 방식 변경 필요할 수도..(현재는 기존 방식 유지)
struct SearchView: View {
    @StateObject var viewModel: SearchViewModel
    @FocusState var searchBarFocused: Bool
    @Binding var isSearchAcivated: Bool

    var body: some View {
        VStack(spacing: 16) {
            SearchBar(viewModel: self.viewModel, isSearchActivated: $isSearchAcivated, searchBarFocused: _searchBarFocused)
            ScrollView {
                if viewModel.searchText.isEmpty {
                    SearchSuggestionList(viewModel: self.viewModel, searchBarFocused: _searchBarFocused)
                } else if viewModel.shortcutResults.isEmpty && viewModel.postResults.isEmpty {
                    EmptyResultView(searchText: $viewModel.searchText)
                } else {
                    ResultSection(viewModel: self.viewModel)
                }
            }
            .onTapGesture {
                if searchBarFocused {
                    searchBarFocused = false
                } else {
                    withAnimation {
                        isSearchAcivated = false
                    }
                }
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background( SCZColor.CharcoalGray.opacity24.ignoresSafeArea() )
        .onChange(of: viewModel.searchText) { _ in
            viewModel.didChangedSearchText()
            if !viewModel.searchText.isEmpty {
                viewModel.isSearched = true
            } else {
                viewModel.shortcutResults.removeAll()
                viewModel.isSearched = false
            }
        }
    }
}

struct EmptyResultView: View {
    @Binding var searchText: String
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            Text(TextLiteral.searchViewEmptyResult(searchText))
                .foregroundStyle(SCZColor.CharcoalGray.opacity48)
                .padding(.horizontal, 16)
                .padding(.vertical, 8)
            Divider()
                .padding(.vertical, 10)
            Button{
                print("단축어 작성 페이지 연결")
            } label: {
                HStack {
                    Text(TextLiteral.searchTextRelatedShortcutShare(searchText))
                        .foregroundStyle(SCZColor.CharcoalGray.opacity64)
                    Spacer()
                    Image(systemName: "chevron.right")
                        .foregroundStyle(SCZColor.CharcoalGray.opacity24)
                }
                .padding(.horizontal, 16)
                .padding(.vertical, 8)
            }
            Divider()
                .padding(.vertical, 10)
            Button{
                print("post 작성 페이지 연결")
            } label: {
                HStack {
                    Text(TextLiteral.searchTextRelatedPost(searchText))
                        .foregroundStyle(SCZColor.CharcoalGray.opacity64)
                    Spacer()
                    Image(systemName: "chevron.right")
                        .foregroundStyle(SCZColor.CharcoalGray.opacity24)
                }
                .padding(.horizontal, 16)
                .padding(.vertical, 8)
            }
        }
        .font(.system(size: 14, weight: .medium))
        .padding(.vertical, 8)
        .background(
            ZStack {
                Color.white.opacity(0.64)
                SCZColor.CharcoalGray.opacity08
            }
        )
        .clipShape(RoundedRectangle(cornerRadius: 16))
        .roundedBorder(cornerRadius: 16, color: Color.white, isNormalBlend: true, opacity: 0.12)
        .padding(.horizontal, 16)
        .onTapGesture { }
    }
}

struct ResultSection: View {
    let maxNum = 2
    
    @StateObject var viewModel: SearchViewModel
    
    //TODO: Post 구조 추가
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            if !viewModel.shortcutResults.isEmpty {
                VStack (alignment: .leading, spacing: 8) {
                    if !viewModel.postResults.isEmpty {
                        Text(TextLiteral.searchViewRelatedShortcut)
                            .font(.system(size: 14, weight: .medium))
                            .foregroundStyle(SCZColor.CharcoalGray.opacity48)
                            .padding(.horizontal, 12)
                    }
                    VStack(alignment: .leading, spacing: 6) {
                        ForEach(Array(viewModel.shortcutResults.prefix(maxNum).enumerated()), id: \.offset) { index, shortcut in
                            ResultShortcutCell(shortcut: shortcut)
                            
                            if index != viewModel.shortcutResults.count-1 || viewModel.shortcutResults.count > maxNum {
                                Divider()
                                    .padding(.vertical, 8)
                                    .foregroundStyle(SCZColor.CharcoalGray.opacity08)
                            }
                        }
                        
                        if viewModel.shortcutResults.count > maxNum {
                            Button {
                                print("더많은 검색결과")
                            } label: {
                                HStack {
                                    Text(TextLiteral.searchViewMoreResult)
                                        .font(.system(size: 14, weight: .medium))
                                        .foregroundStyle(SCZColor.CharcoalGray.opacity48)
                                    Spacer()
                                    Image(systemName: "chevron.right")
                                        .foregroundStyle(SCZColor.CharcoalGray.opacity24)
                                }
                                .padding(.horizontal, 16)
                            }
                        }
                    }
                    .padding(.vertical, 16)
                    .background(
                        ZStack {
                            Color.white.opacity(0.64)
                            SCZColor.CharcoalGray.opacity08
                        }
                    )
                    .roundedBorder(cornerRadius: 16, color: Color.white, isNormalBlend: true, opacity: 0.12)
                }
            }
            
            if !viewModel.postResults.isEmpty {
                VStack (alignment: .leading, spacing: 8) {
                    if !viewModel.shortcutResults.isEmpty {
                        Text(TextLiteral.searchVIewRelatedPost)
                            .font(.system(size: 14, weight: .medium))
                            .foregroundStyle(SCZColor.CharcoalGray.opacity48)
                            .padding(.horizontal, 12)
                    }
                    VStack(alignment: .leading, spacing: 6) {
                        ForEach(Array(viewModel.postResults.prefix(maxNum).enumerated()), id: \.offset) { index, post in
                            ResultPostCell(post: post)
                            if index != viewModel.postResults.count-1 || viewModel.postResults.count>maxNum {
                                Divider()
                                    .padding(.vertical, 8)
                                    .foregroundStyle(SCZColor.CharcoalGray.opacity08)
                            }
                        }
                        
                        if viewModel.postResults.count > maxNum {
                            Button {
                                print("더많은 검색결과")
                            } label: {
                                HStack {
                                    Text(TextLiteral.searchViewMoreResult)
                                        .font(.system(size: 14, weight: .medium))
                                        .foregroundStyle(SCZColor.CharcoalGray.opacity48)
                                    Spacer()
                                    Image(systemName: "chevron.right")
                                        .foregroundStyle(SCZColor.CharcoalGray.opacity24)
                                }
                                .padding(.horizontal, 16)
                            }
                        }
                    }
                    .padding(.vertical, 16)
                    .background(
                        ZStack {
                            Color.white.opacity(0.64)
                            SCZColor.CharcoalGray.opacity08
                        }
                    )
                    .roundedBorder(cornerRadius: 16, color: Color.white, isNormalBlend: true, opacity: 0.12)
                }
            }
        }
        .padding(.horizontal, 16)
        .onTapGesture { }
    }
}

struct ResultShortcutCell: View {
    let shortcut: Shortcuts
    
    var body: some View {
        Button {
            print("단축어 상세페이지 연결")
        } label: {
            HStack {
                ShortcutIcon(sfSymbol: shortcut.sfSymbol, color: shortcut.color, size: 56)
                VStack(alignment: .leading, spacing: 4) {
                    Text(shortcut.title)
                    //Pretendard bold 16
                        .font(.system(size: 16, weight: .bold))
                        .foregroundStyle(SCZColor.Basic)
                        .lineLimit(1)
                    Text(shortcut.subtitle.replacingOccurrences(of: "\\n", with: "\n"))
                    //Pretendard medieum 14
                        .font(.system(size: 14, weight: .medium))
                        .foregroundStyle(SCZColor.CharcoalGray.opacity48)
                        .multilineTextAlignment(.leading)
                        .lineLimit(2)
                }
                Spacer()
                Image(systemName: "chevron.right")
                    .foregroundStyle(SCZColor.CharcoalGray.opacity24)
            }
            .padding(.horizontal, 16)
        }
    }
}

struct ResultPostCell: View {
    let post: Post
    
    var body: some View {
        Button {
            print("post 상세페이지 연결")
        } label: {
            HStack {
                //Pretendard medieum 14
                VStack(alignment: .leading, spacing: 8) {
                    HStack(spacing: 8) {
                        Text(post.author)
                            .foregroundStyle(SCZColor.CharcoalGray.opacity64)
                        Text(post.createdAt.getPostDateFormat() ?? "")
                            .foregroundStyle(SCZColor.CharcoalGray.opacity48)
                    }
                    .lineLimit(1)
                    Text(post.content.replacingOccurrences(of: "\\n", with: "\n"))
                        .foregroundStyle(SCZColor.CharcoalGray.opacity64)
                        .multilineTextAlignment(.leading)
                        .lineLimit(2)
                        .frame(maxWidth: .infinity, alignment: .leading)
                }
                .font(.system(size: 14, weight: .medium))
                Spacer()
                Image(systemName: "chevron.right")
                    .foregroundStyle(SCZColor.CharcoalGray.opacity24)
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(.horizontal, 16)
        }
    }
}

struct SearchSuggestionList: View {
    @StateObject var viewModel: SearchViewModel
    @FocusState var searchBarFocused: Bool
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            if viewModel.searchHistory.isEmpty {
                //추천 검색어
                ForEach(0..<viewModel.keywords.keyword.count, id: \.self) { index in
                    Button {
                        withAnimation {
                            viewModel.searchText = viewModel.keywords.keyword[index]
                            searchBarFocused = false
                        }
                    } label: {
                        HStack(spacing: 8) {
                            Image(systemName: "sparkle")
                                .foregroundStyle(Color.white)
                            Text(viewModel.keywords.keyword[index])
                            //Pretendard 16 regular
                                .font(.system(size: 16, weight: .regular))
                                .foregroundStyle(SCZColor.CharcoalGray.opacity64)
                        }
                        .frame(maxWidth: .infinity, alignment: .leading)
                    }
                    .padding(.horizontal, 16)
                    .padding(.vertical, 8)
                    
                    if index != viewModel.keywords.keyword.count-1 {
                        Divider()
                            .padding(.vertical, 10)
                            .foregroundStyle(SCZColor.CharcoalGray.opacity08)
                    }
                }
            } else {
                //검색 기록
                ForEach(0..<viewModel.searchHistory.count, id: \.self) { index in
                    HStack {
                        Button {
                            withAnimation {
                                viewModel.searchText = viewModel.searchHistory[index]
                                searchBarFocused = false
                            }
                        } label: {
                            HStack(spacing: 8) {
                                Image(systemName: "clock.arrow.circlepath")
                                    .foregroundStyle(Color.white)
                                Text(viewModel.searchHistory[index])
                                //Pretendard 16 regular
                                    .font(.system(size: 16, weight: .regular))
                                    .foregroundStyle(SCZColor.CharcoalGray.opacity88)
                                    .multilineTextAlignment(.leading)
                                    .frame(maxWidth: .infinity, alignment: .leading)
                            }
                        }
                        Button {
                            withAnimation {
                                viewModel.removeSearchHistory(index: index)
                            }
                        } label: {
                            Image(systemName: "xmark")
                                .foregroundStyle(SCZColor.CharcoalGray.opacity24)
                        }
                    }
                    .padding(.horizontal, 16)
                    .padding(.vertical, 8)
                    
                    if index != viewModel.searchHistory.count-1 {
                        Divider()
                            .padding(.vertical, 10)
                            .foregroundStyle(SCZColor.CharcoalGray.opacity08)
                    }
                }
            }
        }
        .padding(.vertical, 8)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(
            ZStack {
                Color.white.opacity(0.64)
                SCZColor.CharcoalGray.opacity08
            }
        )
        .clipShape(RoundedRectangle(cornerRadius: 16))
        .roundedBorder(cornerRadius: 16, color: .white, isNormalBlend: true, opacity: 0.12)
        .padding(.horizontal, 16)
        .onTapGesture { }
    }
}
struct SearchBar: View {
    @StateObject var viewModel: SearchViewModel
    @Binding var isSearchActivated: Bool
    @FocusState var searchBarFocused: Bool
    
    var body: some View {
        HStack {
            Image(systemName: "sparkle.magnifyingglass")
                .foregroundStyle(SCZColor.CharcoalGray.opacity48)
            TextField(TextLiteral.searchViewPrompt, text: $viewModel.searchText)
                .foregroundStyle(SCZColor.CharcoalGray.opacity88)
                .frame(maxHeight: .infinity)
                .focused($searchBarFocused)
                .task {
                    searchBarFocused = true
                }
                .onChange(of: searchBarFocused) { _ in
                    if !searchBarFocused && !viewModel.searchText.isEmpty && isSearchActivated {
                        viewModel.addSearchHistory(text: viewModel.searchText)
                    }
                }
            Button {
                withAnimation {
                    if viewModel.searchText.isEmpty {
                        isSearchActivated = false
                    } else {
                        viewModel.searchText = ""
                        searchBarFocused = true
                    }
                }
            } label: {
                Image(systemName: "xmark")
                    .foregroundStyle(SCZColor.CharcoalGray.opacity24)
            }
        }
        .padding(.horizontal, 16)
        .frame(height: 48)
        .background(
            ZStack {
                Color.white
                SCZColor.CharcoalGray.opacity08
            }
        )
        .overlay(
            Capsule()
                .stroke(Color.white.opacity(0.12), lineWidth: 2)
        )
        .clipShape(Capsule())
        .padding(.horizontal, 16)
        .onTapGesture { }
    }
}
