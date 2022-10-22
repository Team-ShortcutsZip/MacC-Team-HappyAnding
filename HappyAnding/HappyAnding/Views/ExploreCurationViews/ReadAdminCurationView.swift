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
 -
 */

struct ReadCurationView: View {
    
    //TODO: 큐레이션 데이터 모델 제작 후 해당 ObsrvdObjt 삭제 필요.
    @ObservedObject var shortcutData = fetchData()
    
    let title: String = "워라벨 지키기, 단축어와 함께"
    let subtitle: String = "워라벨을 알차게 지키고 있는 에디터도 애용하고 있는 단축어 모음."
    let curationThumbnail: String = "adminCurationTestImage"

    var body: some View {
        ScrollView {
            curationThumbnailImage
                .padding(.bottom, 20)
            titleAndSubtitle
                .padding(.bottom, 20)
            curationShortcutsListTest
        }
        .ignoresSafeArea()
        .background(Color.Background)
    }
    
    ///최상단의 썸네일 이미지 영역입니다.
    var curationThumbnailImage: some View {
        Image(curationThumbnail)
            .resizable()
            .frame(height:304)
    }
    
    ///제목과 부제목 영역입니다.
    var titleAndSubtitle: some View {
        HStack {
            VStack(alignment: .leading, spacing: 4) {
                Text(title)
                    .Title2()
                    .foregroundColor(.Gray5)
                Text(subtitle)
                    .Body2()
                    .foregroundColor(.Gray4)
            }
            Spacer()
        }
        .padding(.horizontal, 16)
    }
    
    ///큐레이션된 단축어 리스트입니다.
    ///현재 테스트용으로 ListShortcutView의 코드를 재활용했습니다.
    ///지금 제목과 큐레이션 사이 padding이 기존 20보다 더 들어가 있어 수정이 필요합니다.
    //TODO: 큐레이션 데이터 모델 제작 후 적용 필요.
    var curationShortcutsListTest: some View {
        ForEach(0..<7, id: \.self) { index in
            ShortcutCell(color: self.shortcutData.data[index].color,
                         sfSymbol: self.shortcutData.data[index].sfSymbol,
                         name: self.shortcutData.data[index].name,
                         description: self.shortcutData.data[index].description,
                         numberOfDownload: self.shortcutData.data[index].numberOfDownload,
                         downloadLink: self.shortcutData.data[index].downloadLink)
        }
    }
}

struct ReadCurationView_Previews: PreviewProvider {
    static var previews: some View {
        ReadCurationView()
    }
}
