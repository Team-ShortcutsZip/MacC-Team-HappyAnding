//
//  ExpandedRankingView.swift
//  HappyAnding
//
//  Created by JeonJimin on 4/2/24.
//

import SwiftUI

struct ExpandedRankingView: View {
    let type: SectionType
    let shortcuts: [Shortcuts]
    
    var body: some View {
        ScrollView(.vertical) {
            VStack(spacing: 5) {
                ForEach(0..<shortcuts.count, id: \.self) { i in
                    VStack (spacing: 5) {
                        ExpandedShortcutCell(type: type, index: i+1, shortcut: shortcuts[i])
                        
                        if i != shortcuts.count - 1 {
                            Divider()
                                .padding(.vertical, 8)
                                .foregroundStyle(SCZColor.CharcoalGray.opacity08)
                        }
                    }
                    .padding(.horizontal, 12)
                }
            }
            .padding(.top, 12)
            .padding(.bottom, 22)
        }
        .toolbar{
            ToolbarItem(placement: .principal) {
                type.fetchTitleImage()
            }
            ToolbarItem(placement: .topBarTrailing) {
                Button {
                    //TODO: 기능 연결
                } label: {
                    Image(systemName: "line.3.horizontal.decrease")
                        .foregroundStyle(SCZColor.CharcoalGray.opacity64)
                }
            }
        }
    }
}

struct ExpandedShortcutCell: View {
    let type: SectionType
    let index: Int
    let shortcut: Shortcuts
    var body: some View {
        HStack(spacing: 14) {
            if type == .popular || type == .download {
                Seal(index: index, type: .ranking)
            }
            ShortcutIcon(sfSymbol: shortcut.sfSymbol, color: shortcut.color, size: 56)
            
            VStack(alignment: .leading, spacing: 2) {
                Text(shortcut.title)
                    .font(.system(size: 16, weight: .bold))
                    .foregroundStyle(SCZColor.Basic)
                Text(shortcut.subtitle)
                    .font(.system(size: 14, weight: .medium))
                    .foregroundStyle(SCZColor.CharcoalGray.opacity48)
            }
            .lineLimit(1)
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(.vertical, 5)
            
            Image(systemName: "chevron.right")
                .foregroundStyle(SCZColor.CharcoalGray.opacity24)
        }
        .padding(.vertical, 6)
    }
}
