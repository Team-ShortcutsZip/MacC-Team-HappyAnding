//
//  SearchView.swift
//  HappyAnding
//
//  Created by 이지원 on 2022/11/09.
//

import SwiftUI

struct SearchView: View {
    
    @State var searchText: String = ""
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack {
                    
                }
            }
            .searchable(text: $searchText) {
                
            }
            .onSubmit(of: .search, runSearch)
            
     //       searchBar
      //      searchResultList
        }
    }
    
    private func runSearch() {
        Task {
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
