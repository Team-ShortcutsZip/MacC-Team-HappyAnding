//
//  ListCurationView.swift
//  HappyAnding
//
//  Created by 이지원 on 2022/10/19.
//
import SwiftUI

/**
 Parameter
 - UserCurations: 화면에서 보여줘야할 큐레이션 리스트를 전달해주세요
 - type:  나의 큐레이션으로 접근하는 경우 .myCuration, 그외의 접근인 경우 .userCuration을 전달해주세요
 - title: curation의 제목이 있는 경우 전달해주세요. 리스트 상단부분에 들어갑니다.  예시) 스마트한 생활의 시작
 */

struct ListCurationView: View {
    
    @EnvironmentObject var shortcutsZipViewModel: ShortcutsZipViewModel
    
    @State var curationType: CurationType
    @State var curations = [Curation]()
    
    private var sectionTitle: String {
        if curationType == .personalCuration {
            return (shortcutsZipViewModel.userInfo?.nickname ?? "") + curationType.title
        } else {
            return curationType.title
        }
    }
    
    var body: some View {
        VStack {
            if curations.isEmpty {
                Text("아직 \(sectionTitle)\(sectionTitle.contains("단축어") ? "가" : "이") 없어요")
                    .shortcutsZipBody2()
                    .foregroundColor(Color.gray4)
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                
            } else {
                ScrollView {
                    LazyVStack(spacing: 0) {
                        Rectangle()
                            .fill(Color.shortcutsZipBackground)
                            .frame(height: 20)
                        
                        makeCurationCellList(curations)
                        
                        Rectangle()
                            .fill(Color.shortcutsZipBackground)
                            .frame(height: 32)
                    }
                }
                .scrollIndicators(.hidden)
                .scrollContentBackground(.hidden)
                .listStyle(.plain)
            }
        }
        .background(Color.shortcutsZipBackground.ignoresSafeArea(.all, edges: .all))
        .navigationBarBackground ({ Color.shortcutsZipBackground })
        .navigationBarTitleDisplayMode(.inline)
        .navigationTitle(sectionTitle)
        .onAppear {
            curations = curationType.filterCuration(from: shortcutsZipViewModel)
        }
    }
    
    @ViewBuilder
    private func makeCurationCellList(_ curations: [Curation]) -> some View {
        ForEach(Array(curations.enumerated()), id: \.offset) { index, curation in
            
            let data = NavigationReadUserCurationType(userCuration: curation,
                                                      navigationParentView: .curations)
            
            UserCurationCell(curation: curation,
                             lineLimit: 2,
                             navigationParentView: .curations)
            .navigationLinkRouter(data: data)
            .listRowInsets(EdgeInsets())
            .listRowSeparator(.hidden)
            .listRowBackground(Color.shortcutsZipBackground)
        }
    }
}

