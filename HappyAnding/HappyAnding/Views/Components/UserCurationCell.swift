//
//  UserCurationCell.swift
//  HappyAnding
//
//  Created by 이지원 on 2022/10/20.
//

import SwiftUI

//MARK: - UserCurationCell 구현 시작

struct UserCurationCell: View {
    
    @State var curation: Curation
    let navigationParentView: NavigationParentView
    
    var body: some View {
        ZStack {
            //TODO: userCuration 모델에 nickname 파라미터 통합 필요
            
            VStack (alignment: .leading, spacing: 0) {
                
                //MARK: - 단축어 아이콘 배열
                
                HStack {
                    ForEach(Array(curation.shortcuts.enumerated()), id: \.offset) { index, shortcut in
                        if index < 4 {
                            ZStack {
                                Rectangle()
                                    .fill(Color.fetchGradient(
                                        color: shortcut.color)
                                    )
                                    .cornerRadius(8)
                                    .frame(width: 36, height: 36)
                                Image(systemName: shortcut.sfSymbol)
                                    .foregroundColor(Color.Text_icon)
                                    .font(.system(size: 15))
                            }
                        }
                    }
                    
                    //단축어가 4개 이상인 경우에만 그리는 아이콘
                    if curation.shortcuts.count > 4 {
                        ZStack(alignment: .center) {
                            Rectangle()
                                .fill(Color.Gray2)
                                .cornerRadius(8)
                                .frame(width: 36, height: 36)
                            HStack(spacing: 0) {
                                Image(systemName: "plus")
                                Text("\(curation.shortcuts.count-4)")
                            }
                            .foregroundColor(.Gray5)
                            .Footnote()
                        }
                    }
                }
                .padding(.bottom, 12)
                .padding(.top, 52)
                
                //MARK: - curation title, subtitle
                
                Text(curation.title)
                    .Headline()
                    .foregroundColor(Color.Gray5)
                    .frame(maxWidth: .infinity, alignment: .leading)
                Text(curation.subtitle)
                    .Body2()
                    .multilineTextAlignment(.leading)
                    .lineLimit(10)
                    .foregroundColor(Color.Gray5)
                    .padding(.bottom, 20)
                    .fixedSize(horizontal: false, vertical: true)
            }
            .onAppear() {
                curation.shortcuts = curation.shortcuts.sorted { $0.title < $1.title }
            }
            .padding(.horizontal, 24)
            .background(Color.Background_list)
            .overlay(
                RoundedRectangle(cornerRadius: 12)
                    .strokeBorder(Color.Background_list_border, lineWidth: 1)
            )
            .frame(maxWidth: .infinity)
            .cornerRadius(12)
        }
        .padding(.horizontal, 16)
        .padding(.bottom, 12)
    }
}

//struct UserCurationCell_Previews: PreviewProvider {
//    static var previews: some View {
//        VStack {
//            UserCurationCell(
//                title: "워라벨 지키기. 단축어와 함께",
//                subtitle: "nil",
//                shortcuts: Shortcut.fetchData(number: 5)
//            )
//        }
//    }
//}
