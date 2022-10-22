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
 
 #description
 - ShortcutTestModel 파일에서 생성한 Shortcut모델을 기준으로 데이터를 받아옵니다.
 */

struct ExploreCategoryView: View {
    
    //TODO: 단축어 목록 받아오기
    let lovedShortcuts = Shortcut.fetchData(number: 10)
    let rankingShortcuts = Shortcut.fetchData(number: 10)
    
    var body: some View {
        VStack {
            List {
                Text("카테고리에 대한 설명이 조금 들어가면 좋을 것 같아요 가나다라마바사")
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
                    ListHeader(title: "다운로드 순위")
                        .padding(.top, 20)
                        .listRowBackground(Color.Background)
                    ForEach(rankingShortcuts.indices, id: \.self) { index in
                        if index < 3 {
                            ShortcutCell(
                                color: rankingShortcuts[index].color,
                                sfSymbol: rankingShortcuts[index].sfSymbol,
                                name: rankingShortcuts[index].name,
                                description: rankingShortcuts[index].description,
                                numberOfDownload: rankingShortcuts[index].numberOfDownload,
                                downloadLink: rankingShortcuts[index].downloadLink
                            )
                        }
                    }
                    .listRowInsets(EdgeInsets())
                    .listRowSeparator(.hidden)
                }
                Section() {
                    ListHeader(title: "사랑받는 단축어")
                        .padding(.top, 20)
                        .listRowBackground(Color.Background)
                    ForEach(lovedShortcuts.indices, id: \.self) { index in
                        if index < 3 {
                            ShortcutCell(
                                color: lovedShortcuts[index].color,
                                sfSymbol: lovedShortcuts[index].sfSymbol,
                                name: lovedShortcuts[index].name,
                                description: lovedShortcuts[index].description,
                                numberOfDownload: lovedShortcuts[index].numberOfDownload,
                                downloadLink: lovedShortcuts[index].downloadLink
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

struct ListHeader: View {
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
                    .foregroundColor(.Gray4 )
                    .frame(maxWidth: .infinity, alignment: .trailing)
                NavigationLink(destination: ListShortcutView()){}.opacity(0)
            }
        }
    }
}

struct ExploreCategoryView_Previews: PreviewProvider {
    static var previews: some View {
        ExploreCategoryView()
    }
}
