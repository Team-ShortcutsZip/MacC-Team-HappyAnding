//
//  UserCurationCell.swift
//  HappyAnding
//
//  Created by 이지원 on 2022/10/20.
//

import SwiftUI

//MARK: - UserCurationCell 구현 시작

struct UserCurationCell: View {
    //title, subtitle, [단축어모델]을 가지는 객체를 받아옴
    let title: String
    let subtitle: String?
    let shortcuts: [Shortcut]
    
    var body: some View {
        ZStack {
            NavigationLink(destination: ReadCurationView()) {
                EmptyView()
            }.opacity(0)
            VStack (alignment: .leading, spacing: 0) {
                
                //MARK: - 단축어 아이콘 배열
                
                HStack {
                    ForEach(Array(shortcuts.enumerated()), id: \.offset) { index, shortcut in
                        if index < 4 {
                            ZStack {
                                Rectangle()
                                    .fill(Color.fetchGradient(
                                        color: shortcut.color)
                                    )
                                    .cornerRadius(8)
                                    .frame(width: 36, height: 36)
                                Image(systemName: shortcut.sfSymbol)
                                    .foregroundColor(Color.White)
                                    .font(.system(size: 15))
                            }
                        }
                    }
                    
                    //단축어가 4개 이상인 경우에만 그리는 아이콘
                    if shortcuts.count > 4 {
                        ZStack(alignment: .center) {
                            Rectangle()
                                .fill(Color.Gray2)
                                .cornerRadius(8)
                                .frame(width: 36, height: 36)
                            HStack(spacing: 0) {
                                Image(systemName: "plus")
                                Text("\(shortcuts.count-4)")
                            }
                            .foregroundColor(.Gray5)
                            .Footnote()
                        }
                    }
                }
                .padding(.bottom, 12)
                .padding(.top, 52)
                
                //MARK: - curation title, subtitle
                
                Text(title)
                    .Headline()
                    .foregroundColor(Color.Gray5)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.bottom, subtitle == nil ? 20 : 0)
                if let subtitle {
                    Text(subtitle)
                        .Body2()
                        .multilineTextAlignment(.leading)
                        .foregroundColor(Color.Gray5)
                        .padding(.bottom, 20)
                }
            }
            .padding(.horizontal, 24)
            .background(Color.White)
            .overlay(
                RoundedRectangle(cornerRadius: 12)
                    .stroke(Color.Gray1, lineWidth: 1)
            )
            .frame(maxWidth: .infinity)
            .cornerRadius(12)
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 6)
    }
}

struct UserCurationCell_Previews: PreviewProvider {
    static var previews: some View {
        VStack {
            UserCurationCell(
                title: "워라벨 지키기. 단축어와 함께",
                subtitle: nil,
                shortcuts: Shortcut.fetchData(number: 5)
            )
        }
    }
}
