//
//  ExploreCategoryView.swift
//  HappyAnding
//
//  Created by 이지원 on 2022/10/19.
//

import SwiftUI

/**
 ExploreCategoryView
 #parameters
 - lovedShortcuts: 사랑받는 단축어 목록
 - rankingShortcuts: 다운로드 순위 단축어 목록
 - 카테고리 선택할 때 이 뷰에 넘겨줘야하는 카테고리 이름입니다.
 - categoryDescriptions: 카테고리 설명글
 
 #description
 - ShortcutTestModel 파일에서 생성한 Shortcut모델을 기준으로 데이터를 받아옵니다.
 */
/*
<<<<<<< HEAD
=======

>>>>>>> 921d9600b92f12b0832275415f08118fb711463f
struct ExploreCategoryView: View {
    
    //TODO: 단축어 목록 받아오기
//    let lovedShortcuts = Shortcut.fetchData(number: 10)
//    let rankingShortcuts = Shortcut.fetchData(number: 10)
    
    @State var lovedShortcuts: [Shortcuts] = []
    @State var rankingShortcuts: [Shortcuts] = []
    
    let firebase = FirebaseService()
    
    let category: Category
    let shortcuts:[Shortcuts]?
    
    var body: some View {
        VStack {
            List {
                Text(category.fetchDescription())
                    .foregroundColor(.Gray5)
                    .Body2()
                    .padding(16)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .background(
                        Rectangle()
                            .foregroundColor(Color.Gray1)
                            .cornerRadius(12)
                    )
                    .listRowInsets(
                        EdgeInsets(
                            top: 20,
                            leading: 16,
                            bottom: 0,
                            trailing: 16
                        )
                    )
                    .listRowSeparator(.hidden)
                    .listRowBackground(Color.Background)
                Section() {
                    CategoryListHeader(type: .download, category: category, shortcuts: rankingShortcuts)
                        .padding(.top, 20)
                        .listRowBackground(Color.Background)
                    if let rankingShortcuts {
                        ForEach(Array(rankingShortcuts.enumerated()), id: \.offset) { index, shortcut in
                            if index < 3 {
                                ShortcutCell(shortcut: shortcut)
                            }
                        }
                        .listRowInsets(EdgeInsets())
                        .listRowSeparator(.hidden)
                    }
                    
                }
                Section() {
                    CategoryListHeader(type: .popular, shortcuts: lovedShortcuts)
                        .padding(.top, 20)
                        .listRowBackground(Color.Background)
                    if let lovedShortcuts {
                        ForEach(Array(lovedShortcuts.enumerated()), id: \.offset) { index, shortcut in
                            if index < 3 {
                                ShortcutCell(shortcut: shortcut)
                            }
                        }
                        .listRowInsets(EdgeInsets())
                        .listRowSeparator(.hidden)
                    }
                    
                }
            }
            .listStyle(.plain)
            .background(Color.Background.ignoresSafeArea(.all, edges: .all))
            .scrollContentBackground(.hidden)
        }
        .navigationBarTitle(category.translateName())
        .onAppear() {
            firebase.fetchCategoryOrderedShortcut(category: category.rawValue, orderBy: "numberOfLike") { shortcuts in
                lovedShortcuts = shortcuts
            }
            firebase.fetchCategoryOrderedShortcut(category: category.rawValue, orderBy: "numberOfDownload") { shortcuts in
                rankingShortcuts = shortcuts
            }
        }
    }
}

struct CategoryListHeader: View {
    var type: SectionType
    var category: Category?
    var shortcuts: [Shortcuts]?
    var body: some View {
        HStack(alignment: .bottom) {
            Text(type.rawValue)
                .Title2()
                .foregroundColor(.Gray5)
            Spacer()
            ZStack {
                Text("더보기")
                    .Footnote()
                    .foregroundColor(.Gray4)
                    .frame(maxWidth: .infinity, alignment: .trailing)
                NavigationLink(destination: ListShortcutView(shortcuts: shortcuts, categoryName: category, sectionType: type)){}.opacity(0)
            }
        }
    }
}
*/
