//
//  SearchView.swift
//  HappyAnding
//
//  Created by 이지원 on 2022/11/09.
//

import SwiftUI

struct SearchView: View {
    
    @State var searchText: String = ""
    @State var searchResult: [Shortcuts]  = []
    
    let keywords: [String] = ["단축어", "갓생", "포항꿀주먹"]
    
    var body: some View {
        NavigationStack {
            ScrollView {
                if searchText == "" && searchResult.count == 0 {
                    recommendKeword
                } else {
                    VStack {
                        Text("hi")
                    }
                }
            }
            .searchable(text: $searchText) {
                
            }
            .onSubmit(of: .search, runSearch)
        }
    }
    
    private func runSearch() {
        Task {
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
                .padding(.leading, 16)
            }
        }
    }
    
    /*
    // MARK: - 검색 바
    
    var searchBar: some View {
        
        HStack {
            Image(systemName: "magnifyingglass")
            
            TextField("단축어 이름, 앱 이름으로 검색해보세요", text: $searchText)
                .onSubmit {
                    
                    // TODO: Firebase 함수 연결
                    
                    print("Firebase 함수 호출")
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
            ForEach(result, id: \.self) { shortcut in
                
                Text(shortcut)
                
            }
        }
    }
         */
    
}

struct SearchView_Previews: PreviewProvider {
    static var previews: some View {
        SearchView()
    }
}
