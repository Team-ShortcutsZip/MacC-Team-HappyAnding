//
//  UserCurationCell.swift
//  HappyAnding
//
//  Created by 이지원 on 2022/10/20.
//

import SwiftUI

//MARK: - UserCurationCell 구현 시작

struct UserCurationCell: View {
    
    @EnvironmentObject var shortcutsZipViewModel: ShortcutsZipViewModel
    
    @State var curation: Curation
    @State var index = 0
    
    var lineLimit: Int?
    let navigationParentView: NavigationParentView
    
    var body: some View {
        ZStack {
            VStack (alignment: .leading, spacing: 0) {
                
                //MARK: - 단축어 아이콘 배열
                HStack {
                    ForEach(shortcutsZipViewModel.userCurations[index].shortcuts.prefix(4), id: \.self) { shortcut in
                        ZStack {
                            Rectangle()
                                .fill(Color.fetchGradient(color: shortcut.color))
                                .cornerRadius(8)
                                .frame(width: 36, height: 36)
                            Image(systemName: shortcut.sfSymbol)
                                .foregroundColor(Color.textIcon)
                                .SmallShortcutIcon()
                        }
                    }
                    
                    //단축어가 4개 이상인 경우에만 그리는 아이콘
                    if shortcutsZipViewModel.userCurations[index].shortcuts.count > 4 {
                        ZStack(alignment: .center) {
                            Rectangle()
                                .fill(Color.gray2)
                                .cornerRadius(8)
                                .frame(width: 36, height: 36)
                            HStack(spacing: 0) {
                                Image(systemName: "plus")
                                    .SmallIcon()
                                Text("\(shortcutsZipViewModel.userCurations[index].shortcuts.count-4)")
                                    .Footnote()
                            }
                            .foregroundColor(.gray5)
                        }
                    }
                }
                .padding(.bottom, 12)
                .padding(.top, 52)
                
                //MARK: - curation title, subtitle
                
                Text(shortcutsZipViewModel.userCurations[index].title)
                    .Headline()
                    .foregroundColor(Color.gray5)
                    .frame(maxWidth: .infinity, alignment: .leading)
                Text(shortcutsZipViewModel.userCurations[index].subtitle.lineBreaking)
                    .Body2()
                    .multilineTextAlignment(.leading)
                    .lineLimit(lineLimit)
                    .foregroundColor(Color.gray5)
                    .padding(.bottom, 20)
                    .fixedSize(horizontal: false, vertical: true)
            }
            .onAppear() {
                if let index = shortcutsZipViewModel.userCurations.firstIndex(of: curation) {
                    self.index = index
                }
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
