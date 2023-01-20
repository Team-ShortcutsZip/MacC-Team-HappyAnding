//
//  ListCurationView.swift
//  HappyAnding
//
//  Created by 이지원 on 2022/10/19.
//
import SwiftUI

enum CurationType: String {
    case myCuration = "내가 작성한 추천 모음집"
    case userCuration = "사용자 추천 모음집"
    case personalCuration = "님을 위한 추천 모음집"
}

/**
 Parameter
 - UserCurations: 화면에서 보여줘야할 큐레이션 리스트를 전달해주세요
 - type:  나의 큐레이션으로 접근하는 경우 .myCuration, 그외의 접근인 경우 .userCuration을 전달해주세요
 - title: curation의 제목이 있는 경우 전달해주세요. 리스트 상단부분에 들어갑니다.  예시) 스마트한 생활의 시작
 */

struct ListCurationView: View {
    
    @EnvironmentObject var shortcutsZipViewModel: ShortcutsZipViewModel
    @State var data: NavigationListCurationType
    
    var body: some View {
        let titleString = data.type == .personalCuration ? (shortcutsZipViewModel.userInfo?.nickname ?? "") : ""
        if data.curation.count == 0 {
            Text("\(titleString)\(data.type.rawValue)이(가) 없습니다.")
                .Body2()
                .foregroundColor(Color.Gray4)
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .background(Color.Background.ignoresSafeArea(.all, edges: .all))
                .navigationBarTitle("\(titleString)\(data.type.rawValue)")
                .navigationBarTitleDisplayMode(.inline)
        } else {
            ScrollView {
                LazyVStack(spacing: 0) {
                    
                    ForEach(Array(data.curation.enumerated()), id: \.offset) { index, curation in
                        
                        let data = NavigationReadUserCurationType(userCuration: curation,
                                                                  navigationParentView: self.data.navigationParentView)
                        
                        NavigationLink(value: data) {
                            UserCurationCell(curation: curation,
                                             navigationParentView: self.data.navigationParentView,
                                             lineLimit: 2)
                            .listRowInsets(EdgeInsets())
                            .listRowSeparator(.hidden)
                            .listRowBackground(Color.Background)
                            .padding(.top, index == 0 ? 20 : 0 )
                            .padding(.bottom, index == self.data.curation.count - 1 ? 32 : 0)
                        }
                    }
                }
            }
            .scrollIndicators(.hidden)
            .listStyle(.plain)
            .background(Color.Background.ignoresSafeArea(.all, edges: .all))
            .navigationBarBackground ({ Color.Background })
            .scrollContentBackground(.hidden)
            .navigationBarTitleDisplayMode(.inline)
            .navigationTitle(data.title ?? "")
        }
    }
}

