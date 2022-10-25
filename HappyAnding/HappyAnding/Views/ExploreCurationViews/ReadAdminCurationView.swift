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
 - ScrollView Bounce가 아래쪽에서만 되게 해야 합니다.
 - 어드민 큐레이션 데이터가 만들어진 후 데이터 연결이 필요합니다.
 - 네비게이션 뷰 연결 및 설정이 필요합니다.
 - 공유버튼 액션 연결이 필요합니다. (스프린트2 이후)
 */

struct ReadAdminCurationView: View {
    
    //TODO: 큐레이션 데이터 모델 제작 후 해당 ObservedObject 삭제 필요.
    @ObservedObject var shortcutData = fetchData()
        
    let title: String = "워라벨 지키기, 단축어와 함께"
    let subtitle: String = "워라벨을 알차게 지키고 있는 에디터도 애용하고 있는 단축어 모음."
    let curationThumbnail: String = "adminCurationTestImage"
    
    var body: some View {
//        NavigationView {
            ScrollView {
                
                GeometryReader { geo in
                    let yOffset = geo.frame(in: .global).minY > 0 ? -geo.frame(in: .global).minY : 0
                    
                    Image(curationThumbnail)
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: geo.size.width, height: geo.size.height - yOffset)
                        .offset(y: yOffset)
                }
                .frame(height: 304)
                
//                curationThumbnailImage
//                    .padding(.bottom, 20)
                titleAndSubtitle
                //각각의 단축어 셀 상단에 padding이 12씩 들어가 있음.
                    .padding(.bottom, 8)
                curationShortcutsListTest
                Spacer()
                    .frame(height: 44)
            }
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
//        }
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
    ///현재 랜덤한 7개의 단축어를 가져와서 뷰를 그리도록 되어있습니다.
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
        ReadAdminCurationView()
    }
}
