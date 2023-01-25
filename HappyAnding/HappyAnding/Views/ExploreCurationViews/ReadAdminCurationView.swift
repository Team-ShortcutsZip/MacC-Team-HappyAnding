//
//  ReadCurationView.swift
//  HappyAnding
//
//  Created by 이지원 on 2022/10/19.
//

import SwiftUI

/**
 어드민 큐레이션 뷰 입니다.
 #parameters
 - curationThumbnail: 썸네일 배경의 이미지명
 - title: 큐레이션 제목
 - subtitle: 큐레이션 부제목
 
 #description
 - 어드민 큐레이션 데이터가 만들어진 후 데이터 연결이 필요합니다.
 - 네비게이션 뷰 연결 및 설정이 필요합니다.
 - 공유버튼 액션 연결이 필요합니다. (스프린트2 이후)
 */

struct ReadAdminCurationView: View {
    
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    let curation: Curation

    var body: some View {
        ScrollView(showsIndicators: false) {
            
            StickyHeader(height: 304, image: curation.background)
                .padding(.bottom, 20)
            
            titleAndSubtitle
                .padding(.bottom, 8)
            
            VStack(spacing: 0) {
                ForEach(Array(curation.shortcuts.enumerated()), id: \.offset) { index, shortcut in
                    let data = NavigationReadShortcutType(shortcutID: shortcut.id,
                                                          navigationParentView: .curations)
                    NavigationLink(value: data) {
                        ShortcutCell(shortcutCell: shortcut,
                                     navigationParentView: .curations)
                    }
                }
            }
            
            Spacer()
                .frame(height: 44)
        }
        .navigationBarTitleDisplayMode(.inline)
        .edgesIgnoringSafeArea(.top)
        .background(Color.Background)
        
        //TODO: 추후 공유 기능 추가 시 사용할 코드
        //            .toolbar {
        //                ToolbarItem(placement: .navigationBarTrailing) {
        //                    Button(action: {
        //                        //TODO: 네비게이션 연결 후 코드 지우기.
        //                        //TODO: Share 버튼 눌렀을 때 Curation공유 링크 생성 및 actionSheet 나타내기
        //                    }) {
        //                        Image(systemName: "square.and.arrow.up")
        //                            .foregroundColor(.Gray4)
        //                    }
        //                }
        //            }
    }
    
    ///최상단의 썸네일 이미지 영역입니다.
    var curationThumbnailImage: some View {
        Image(curation.background)
            .resizable()
            .frame(height:304)
    }
    
    ///제목과 부제목 영역입니다.
    var titleAndSubtitle: some View {
        HStack {
            VStack(alignment: .leading, spacing: 4) {
                SubtitleTextView(text: curation.title)
                Text(curation.subtitle.replacingOccurrences(of: "\\n", with: "\n"))
                    .Body2()
                    .foregroundColor(.Gray4)
            }
            Spacer()
        }
        .padding(.horizontal, 16)
    }
}

