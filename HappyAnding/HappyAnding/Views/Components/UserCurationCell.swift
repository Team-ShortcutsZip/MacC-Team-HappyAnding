//
//  UserCurationCell.swift
//  HappyAnding
//
//  Created by 이지원 on 2022/10/20.
//

import SwiftUI

struct UserCurationCell: View {
    
    @EnvironmentObject var shortcutsZipViewModel: ShortcutsZipViewModel
    
    @State var curation: Curation
    
    var lineLimit: Int?
    let navigationParentView: NavigationParentView
    
    var body: some View {
        ZStack {
            VStack (alignment: .leading, spacing: 0) {
                
                /// 단축어 아이콘 배열
                HStack {
                    ForEach(curation.shortcuts.prefix(4), id: \.self) { shortcut in
                        ZStack {
                            Rectangle()
                                .fill(Color.fetchGradient(color: shortcut.color))
                                .cornerRadius(8)
                                .frame(width: 36, height: 36)
                            Image(systemName: shortcut.sfSymbol)
                                .foregroundColor(Color.textIcon)
                                .smallShortcutIcon()
                        }
                    }
                    
                    /// 단축어가 4개 이상인 경우에만 그리는 아이콘
                    if curation.shortcuts.count > 4 {
                        ZStack(alignment: .center) {
                            Rectangle()
                                .fill(Color.gray2)
                                .cornerRadius(8)
                                .frame(width: 36, height: 36)
                            HStack(spacing: 0) {
                                Image(systemName: "plus")
                                    .smallIcon()
                                Text("\(curation.shortcuts.count - 4)")
                                    .shortcutsZipFootnote()
                            }
                            .foregroundColor(.gray5)
                        }
                    }
                }
                .padding(.bottom, 12)
                .padding(.top, 52)
                
                Text(curation.title)
                    .shortcutsZipHeadline()
                    .foregroundColor(Color.gray5)
                    .frame(maxWidth: .infinity, alignment: .leading)
                Text(curation.subtitle.lineBreaking)
                    .shortcutsZipBody2()
                    .multilineTextAlignment(.leading)
                    .lineLimit(lineLimit)
                    .foregroundColor(Color.gray5)
                    .padding(.bottom, 20)
                    .fixedSize(horizontal: false, vertical: true)
            }
            .padding(.horizontal, 24)
            .background(Color.backgroudList)
            .overlay(
                RoundedRectangle(cornerRadius: 12)
                    .strokeBorder(Color.backgroudListBorder, lineWidth: 1)
            )
            .frame(maxWidth: .infinity)
            .cornerRadius(12)
        }
        .padding(.horizontal, 16)
        .padding(.bottom, 12)
    }
}
