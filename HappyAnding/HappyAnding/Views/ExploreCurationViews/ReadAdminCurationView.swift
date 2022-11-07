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
    
    //TODO: 큐레이션 데이터 모델 제작 후 해당 ObservedObject 삭제 필요.
    @ObservedObject var shortcutData = fetchData()
    let curation: Curation
    
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>

    var body: some View {
        ScrollView(showsIndicators: false) {
            GeometryReader { geo in
                let yOffset = geo.frame(in: .global).minY
                
                Image(curation.background)
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: geo.size.width, height: 304 + (yOffset > 0 ? yOffset : 0))
                    .clipped()
                    .offset(y: yOffset > 0 ? -yOffset : 0)
            }
            .frame(minHeight: 304)
            .padding(.bottom, 20)
            
            titleAndSubtitle
                .padding(.bottom, 8)
            
            ForEach(Array(curation.shortcuts.enumerated()), id: \.offset) { index, shortcut in
                NavigationLink(value: shortcut.id) {
                    ShortcutCell(shortcutCell: shortcut)
                }
            }
            .navigationDestination(for: String.self) { shortcutID in
                ReadShortcutView(shortcutID: shortcutID)
            }
            
            Spacer()
                .frame(height: 44)
        }
        .navigationBarBackButtonHidden(true)
        .navigationBarItems(leading: btnBack)
        .toolbarBackground(Color.clear, for: .navigationBar)
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
                Text(curation.title)
                    .Title2()
                    .foregroundColor(.Gray5)
                Text(curation.subtitle)
                    .Body2()
                    .foregroundColor(.Gray4)
            }
            Spacer()
        }
        .padding(.horizontal, 16)
    }
    
    var btnBack : some View { Button(action: {
        self.presentationMode.wrappedValue.dismiss()
        }) {
            Image(systemName: "chevron.backward") // set image here
                .foregroundColor(Color.Gray5)
                .bold()
        }
    }
}

