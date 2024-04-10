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
//    @Binding var isSearchAcivated: Bool

    var body: some View {
        VStack(spacing: 12) {
            SearchBar(viewModel: self.viewModel)
            if viewModel.searchText.isEmpty {
                SearchSuggestionList(viewModel: self.viewModel)
            } else if viewModel.shortcutResults.isEmpty && viewModel.postResults.isEmpty {
                EmptyResultView(searchText: $viewModel.searchText)
            } else {
                SearchResultList(shortcuts: viewModel.shortcutResults, posts: viewModel.postResults)
            }
            Spacer()
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(SCZColor.CharcoalGray.opacity24.ignoresSafeArea())
        .onChange(of: viewModel.searchText) { _ in
            viewModel.didChangedSearchText()
            if !viewModel.searchText.isEmpty {
                viewModel.isSearched = true
            } else {
                viewModel.shortcutResults.removeAll()
                viewModel.isSearched = false
            }
        }
        //빈 부분 터치 시 검색화면 벗어나기
//        .onTapGesture {
//            isSearchAcivated.toggle()
//        }
    }
}

struct EmptyResultView: View {
    @Binding var searchText: String
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            Text("😵 \'\(searchText)\'에 관련된 단축어나 글이 없어요.")
                .foregroundStyle(SCZColor.CharcoalGray.opacity48)
                .padding(.horizontal, 16)
                .padding(.vertical, 8)
            Divider()
                .padding(.vertical, 10)
            Button{
                print("단축어 작성 페이지 연결")
            } label: {
                HStack {
                    Text("\'\(searchText)\' 관련 단축어 공유하기")
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
                    Text("\'\(searchText)\' 관련 질문하기")
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
    }
}
enum ResultType {
    case shortcut, post
}

struct SearchResultList: View {
    var shortcuts: [Shortcuts]
    var posts: [[String]]
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 16) {
                if shortcuts.count > 0 {
                    ResultSection(type: .shortcut, title: "관련된 단축어", shortcuts: shortcuts)
                }
                if posts.count > 0 {
                    ResultSection(type: .post, title: "관련된 글", posts: posts)
                }
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(.horizontal, 16)
        }
        .scrollDismissesKeyboard(.immediately)
    }
}

struct ResultSection: View {
    let type: ResultType
    let title: String
    var shortcuts: [Shortcuts]?
    var posts: [[String]]?
    //TODO: Post 구조 추가
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text(title)
                .font(.system(size: 14, weight: .medium))
                .foregroundStyle(SCZColor.CharcoalGray.opacity48)
                .padding(.horizontal, 12)
            
            if let shortcuts {
                VStack(alignment: .leading, spacing: 6) {
                    Rectangle()// 상단 여백을 주기 위함
                        .frame(height: 0.1)
                        .foregroundStyle(Color.clear)
                    ForEach(Array(shortcuts.prefix(3).enumerated()), id: \.offset) { index, shortcut in
                        ResultShortcutCell(shortcut: shortcut)
                        
                        if index != shortcuts.count-1 || shortcuts.count > 3{
                            Divider()
                                .padding(.vertical, 10)
                                .foregroundStyle(SCZColor.CharcoalGray.opacity08)
                        }
                    }
                    
                    if shortcuts.count > 3 {
                        Button {
                            print("더많은 검색결과")
                        } label: {
                            HStack {
                                Text("더 많은 검색 결과 보기")
                                    .font(.system(size: 14, weight: .medium))
                                    .foregroundStyle(SCZColor.CharcoalGray.opacity48)
                                Spacer()
                                Image(systemName: "chevron.right")
                                    .foregroundStyle(SCZColor.CharcoalGray.opacity24)
                            }
                            .padding(.horizontal, 16)
                            .padding(.bottom, 6)
                        }
                    }
                }
                .padding(.vertical, 10)
                .background(
                    ZStack {
                        Color.white.opacity(0.64)
                        SCZColor.CharcoalGray.opacity08
                    }
                )
                .roundedBorder(cornerRadius: 16, color: Color.white, isNormalBlend: true, opacity: 0.12)
            }
            
            if let posts {
                VStack(alignment: .leading, spacing: 6) {
                    Rectangle()// 상단 여백을 주기 위함
                        .frame(height: 0.1)
                        .foregroundStyle(Color.clear)
                    ForEach(Array(posts.prefix(3).enumerated()), id: \.offset) { index, post in
                        ResultPostCell(post: post)
                        
                        if index != posts.count-1 || posts.count>3 {
                            Divider()
                                .padding(.vertical, 10)
                                .foregroundStyle(SCZColor.CharcoalGray.opacity08)
                        }
                    }
                    
                    if posts.count > 3 {
                        Button {
                            print("더많은 검색결과")
                        } label: {
                            HStack {
                                Text("더 많은 검색 결과 보기")
                                    .font(.system(size: 14, weight: .medium))
                                    .foregroundStyle(SCZColor.CharcoalGray.opacity48)
                                Spacer()
                                Image(systemName: "chevron.right")
                                    .foregroundStyle(SCZColor.CharcoalGray.opacity24)
                            }
                            .padding(.horizontal, 16)
                            .padding(.bottom, 6)
                        }
                    }
                }
                .padding(.vertical, 10)
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
                    Text(shortcut.subtitle)
                    //Pretendard medieum 14
                        .font(.system(size: 14, weight: .medium))
                        .foregroundStyle(SCZColor.CharcoalGray.opacity48)
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
    let post: [String]
    
    var body: some View {
        Button {
            print("post 상세페이지 연결")
        } label: {
            HStack {
                Text(post[1])
                //Pretendard medieum 14
                    .font(.system(size: 14, weight: .medium))
                    .foregroundStyle(SCZColor.CharcoalGray.opacity64)
                Spacer()
                Image(systemName: "chevron.right")
                    .foregroundStyle(SCZColor.CharcoalGray.opacity24)
            }
            .padding(.horizontal, 16)
        }
    }
}

//TODO: 검색기록 추가
struct SearchSuggestionList: View {
    @StateObject var viewModel: SearchViewModel
    
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            
            
            if viewModel.searchHistory.isEmpty {
                //추천 검색어
                ForEach(0..<viewModel.keywords.keyword.count, id: \.self) { index in
                    Button {
                        withAnimation {
                            viewModel.selectKeyword(index: index)
                        }
                    } label: {
                        HStack(spacing: 8) {
                            Image(systemName: "sparkle")
                                .foregroundStyle(Color.white)
                            Text(viewModel.keywords.keyword[index])
                                .shortcutsZipBody2()
                                .foregroundStyle(Color.gray4)
                        }
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
                    Button {
                        withAnimation {
                            viewModel.searchText = viewModel.searchHistory[index]
                        }
                    } label: {
                        HStack(spacing: 8) {
                            Image(systemName: "clock.arrow.circlepath")
                                .foregroundStyle(Color(hexString: "8E8E93"))
                            Text(viewModel.searchHistory[index])
                                .shortcutsZipBody2()
                                .foregroundStyle(Color.gray4)
                                .frame(maxWidth: .infinity, alignment: .leading)
                            Button {
                                withAnimation {
                                    viewModel.removeSearchHistory(index: index)
                                }
                            } label: {
                                Image(systemName: "xmark")
                                    .foregroundStyle(SCZColor.CharcoalGray.opacity24)
                            }
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
    }
}
struct SearchBar: View {
    @StateObject var viewModel: SearchViewModel
    
    var body: some View {
        HStack {
            Image(systemName: "sparkle.magnifyingglass")
                .foregroundStyle(SCZColor.CharcoalGray.opacity48)
            TextField("단축어 제작의 기본", text: $viewModel.searchText) {
                viewModel.addSearchHistory(text: viewModel.searchText)
            }
            .foregroundStyle(SCZColor.CharcoalGray.opacity88)
            .frame(maxHeight: .infinity)
            //TODO: 검색어 비었을 때 한번 더 터치 시 검색화면 벗어나기
            Button {
                withAnimation {
                    viewModel.searchText = ""
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
    }
}

//머지 후 지워질 부분
struct ShortcutIcon: View {
    @Environment(\.colorScheme) var colorScheme

    let sfSymbol: String
    let color: String
    let size: CGFloat

    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 13)
                .foregroundStyle(SCZColor.colors[color]?.color(for: colorScheme).fillGradient() ?? SCZColor.defaultColor)
                .overlay(
                    RoundedRectangle(cornerRadius: 13)
                        .strokeBorder(.white.opacity(0.24), lineWidth: 2)
                )
                .frame(width: size, height: size)
            Image(systemName: sfSymbol)
                .font(.system(size: 28))
                .foregroundStyle(Color.white)
        }
    }
}

#Preview {
    SearchView()
}
