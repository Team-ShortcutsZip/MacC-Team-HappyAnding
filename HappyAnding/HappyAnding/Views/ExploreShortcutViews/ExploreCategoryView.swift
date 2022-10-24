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

struct ExploreCategoryView: View {
    
    //TODO: 단축어 목록 받아오기
    let lovedShortcuts = Shortcut.fetchData(number: 10)
    let rankingShortcuts = Shortcut.fetchData(number: 10)
    
    let category: Category
    
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
                    CategoryListHeader(title: SectionType.download.rawValue)
                        .padding(.top, 20)
                        .listRowBackground(Color.Background)
                    ForEach(Array(rankingShortcuts.enumerated()), id: \.offset) { index, shortcut in
                        if index < 3 {
                            ShortcutCell(
                                color: shortcut.color,
                                sfSymbol: shortcut.sfSymbol,
                                name: shortcut.name,
                                description: shortcut.description,
                                numberOfDownload: shortcut.numberOfDownload,
                                downloadLink: shortcut.downloadLink
                            )
                        }
                    }
                    .listRowInsets(EdgeInsets())
                    .listRowSeparator(.hidden)
                }
                Section() {
                    CategoryListHeader(title: SectionType.popular.rawValue)
                        .padding(.top, 20)
                        .listRowBackground(Color.Background)
                    ForEach(Array(lovedShortcuts.enumerated()), id: \.offset) { index, shortcut in
                        if index < 3 {
                            ShortcutCell(
                                color: shortcut.color,
                                sfSymbol: shortcut.sfSymbol,
                                name: shortcut.name,
                                description: shortcut.description,
                                numberOfDownload: shortcut.numberOfDownload,
                                downloadLink: shortcut.downloadLink
                            )
                        }
                    }
                    .listRowInsets(EdgeInsets())
                    .listRowSeparator(.hidden)
                }
            }
            .listStyle(.plain)
            .background(Color.Background.ignoresSafeArea(.all, edges: .all))
            .scrollContentBackground(.hidden)
        }
    }
}

struct CategoryListHeader: View {
    var title: String
    var body: some View {
        HStack(alignment: .bottom) {
            Text(title)
                .Title2()
                .foregroundColor(.Gray5)
            Spacer()
            ZStack {
                Text("더보기")
                    .Footnote()
                    .foregroundColor(.Gray4)
                    .frame(maxWidth: .infinity, alignment: .trailing)
                NavigationLink(destination: ListShortcutView()){}.opacity(0)
            }
        }
    }
}

struct ExploreCategoryView_Previews: PreviewProvider {
    static var previews: some View {
        ExploreCategoryView(category: Category.business)
    }
}
