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
    
    let category: String
    let categoryDescriptions = [
        "교육":"교육 카테고리에 대한 설명입니다.",
        "금융":"금융 카테고리에 대한 설명입니다.",
        "비즈니스":"비즈니스 카테고리에 대한 설명입니다.",
        "건강 및 피트니스":"건강 및 피트니스 카테고리에 대한 설명입니다.",
        "라이프스타일":"라이프스타일 카테고리에 대한 설명입니다.",
        "날씨":"날씨 카테고리에 대한 설명입니다.",
        "사진 및 비디오":"사진 및 비디오 카테고리에 대한 설명입니다.",
        "꾸미기":"꾸미기 카테고리에 대한 설명입니다.",
        "유틸리티":"유틸리티 카테고리에 대한 설명입니다.",
        "소셜 네트워킹":"소셜 네트워킹 카테고리에 대한 설명입니다.",
        "엔터테인먼트":"엔터테인먼트 카테고리에 대한 설명입니다.",
        "여행":"여행 카테고리에 대한 설명입니다."
    ]
    
    var body: some View {
        VStack {
            List {
                Text(categoryDescriptions[category] ?? "")
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
                    .foregroundColor(.Gray4)
                    .frame(maxWidth: .infinity, alignment: .trailing)
                NavigationLink(destination: ListShortcutView()){}.opacity(0)
            }
        }
    }
}

struct ExploreCategoryView_Previews: PreviewProvider {
    static var previews: some View {
        ExploreCategoryView(category: "교육")
    }
}
