//
//  AdminCurationCell.swift
//  HappyAnding
//
//  Created by 이지원 on 2022/10/20.
//

import SwiftUI

/*
 어드민 큐레이션 썸네일입니다.
 
 #parameters
 - curationThumbnail: 썸네일 배경의 이미지명
 - title: 큐레이션 제목
 - subtitle: 큐레이션 부제목
 
 #description
 - 어드민 큐레이션 데이터가 만들어진 후 데이터 연결이 필요합니다.
 - padding 값이 설정되어있지 않습니다. 사용 시 padding 설정 후 사용해주세요.
 */

struct AdminCurationCell: View {
    
    let curationThumbnail: String
    let title: String
    let subtitle: String
    
    let cornerRadius: CGFloat = 12
    
    var body: some View {
        ZStack(alignment: .top) {
            NavigationLink(destination: ReadCurationView()) {
                EmptyView()
            }
            titleAndSubtitle
                .padding([.leading, .bottom, .trailing], 24.0)
                .padding(.top, 184)
                .background(backgroundImage)
        }
    }
    
    var titleAndSubtitle: some View {
        HStack {
            VStack(alignment: .leading, spacing: 4) {
                Text(title)
                    .Title1()
                    .foregroundColor(.Gray5)
                    .lineLimit(1)
                Text(subtitle)
                    .Body2()
                    .foregroundColor(.Gray5)
                    .lineLimit(2)
            }
            Spacer()
        }
    }
    
    var backgroundImage: some View {
        ZStack {
            Image(curationThumbnail)
                .resizable()
                .clipShape(RoundedRectangle(cornerRadius: cornerRadius))
            RoundedRectangle(cornerRadius: cornerRadius)
                .foregroundColor(.white)
                .opacity(0.4)
        }
    }
}

struct AdminCurationCell_Previews: PreviewProvider {
    static var previews: some View {
        VStack {
            AdminCurationCell(curationThumbnail: "adminCurationTestImage", title: "갓생ㅋ", subtitle: "워라밸도 중요해요")
                .padding(.all, 16.0)
            AdminCurationCell(curationThumbnail: "adminCurationTestImage", title: "갓생, 시작해보고 싶다면", subtitle: "갓생을 살고 싶은 당신을 위해 알람, 타이머, 투두리스트 등의 단축어를 모아봤어요!")
                .padding(.all, 16.0)
        }
    }
}
