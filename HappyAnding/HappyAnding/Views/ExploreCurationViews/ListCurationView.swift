//
//  ListCurationView.swift
//  HappyAnding
//
//  Created by 이지원 on 2022/10/19.
//

import SwiftUI

enum CurationType: String {
    case myCuration = "나의 큐레이션"
    case userCuration = ""
}

/**
 Parameter
 - UserCurations: 화면에서 보여줘야할 큐레이션 리스트를 전달해주세요
 - type:  나의 큐레이션으로 접근하는 경우 .myCuration, 그외의 접근인 경우 .userCuration을 전달해주세요
 - title: curation의 제목이 있는 경우 전달해주세요. 리스트 상단부분에 들어갑니다.  예시) 스마트한 생활의 시작
 */

struct ListCurationView: View {
    
    var userCurations: [UserCuration]
    var type: CurationType
    var title: String?
    
    var body: some View {
        List {
            if let title {
                Text(title)
                    .Title1()
                    .foregroundColor(.Gray5)
                    .listRowInsets(EdgeInsets())
                    .listRowSeparator(.hidden)
                    .listRowBackground(Color.Background)
                    .padding(.horizontal, 16)
            }
            ForEach(Array(userCurations.enumerated()), id: \.offset) { index, curation in
                UserCurationCell(
                    title: curation.title,
                    subtitle: curation.subtitle,
                    shortcuts: curation.shortcuts
                )
                .listRowInsets(EdgeInsets())
                .listRowSeparator(.hidden)
                .listRowBackground(Color.Background)
                .padding(.top, index == 0 ? 20 : 0 )
                .padding(.bottom, index == userCurations.count - 1 ? 32 : 0)
            }
        }
        .listStyle(.plain)
        .background(Color.Background.ignoresSafeArea(.all, edges: .all))
        .scrollContentBackground(.hidden)
        .navigationBarTitle(type.rawValue)
        .navigationBarTitleDisplayMode(.inline)
        
    }
}

struct ListCurationView_Previews: PreviewProvider {
    static var previews: some View {
        ListCurationView(
            userCurations: UserCuration.fetchData(number: 10),
            type: CurationType.userCuration
        )
    }
}
