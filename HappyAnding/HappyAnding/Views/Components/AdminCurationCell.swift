//
//  AdminCurationCell.swift
//  HappyAnding
//
//  Created by 이지원 on 2022/10/20.
//

import SwiftUI

/**
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
    
    let adminCuration: Curation
    let cornerRadius: CGFloat = 12
    
    var body: some View {
        ZStack(alignment: .bottom) {
            NavigationLink(destination: ReadAdminCurationView(curation: adminCuration)) {
                EmptyView()
            }
            backgroundImage
            titleAndSubtitle
                .padding([.horizontal, .bottom], 24)
        }
        .frame(width: UIScreen.main.bounds.width-32, height: 284)
        .padding(.trailing, 8.0)
    }
    
    ///타이틀 및 설명
    var titleAndSubtitle: some View {
        HStack(alignment: .bottom) {
            VStack(alignment: .leading, spacing: 4) {
                Text(adminCuration.title)
                    .Title1()
                    .foregroundColor(.Text_curation)
                    .lineLimit(1)
                Text(adminCuration.subtitle)
                    .Body2()
                    .foregroundColor(.Text_curation)
                    .lineLimit(2)
            }
            Spacer()
        }
    }
    
    
    ///백그라운드 이미지
    var backgroundImage: some View {
        ZStack {
            Image(adminCuration.background)
                .resizable()
                .clipShape(RoundedRectangle(cornerRadius: cornerRadius))
            RoundedRectangle(cornerRadius: cornerRadius)
                .foregroundColor(.white)
                .opacity(0.4)
        }
        .frame(height: 284)
    }
}

struct AdminCurationCell_Previews: PreviewProvider {
    static var previews: some View {
        ZStack {
            Color.Background
            AdminCurationCell(
                adminCuration: Curation(
                    title: "title",
                    subtitle: "subtitle",
                    isAdmin: true,
                    background: "CurationThumbnailDefault",
                    author: "author",
                    shortcuts: [
                        ShortcutCellModel(
                            id: "id",
                            sfSymbol: "bus.fill",
                            color: "Red",
                            title: "title",
                            subtitle: "subtitle",
                            downloadLink: "downloadLink"
                        )
                    ]
                )
            )
        }
    }
}
