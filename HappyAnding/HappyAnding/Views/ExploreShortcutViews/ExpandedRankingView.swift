//
//  ExpandedRankingView.swift
//  HappyAnding
//
//  Created by JeonJimin on 4/2/24.
//

import SwiftUI

struct ExpandedRankingView: View {
    let type: ExploreShortcutSectionType
    let shortcuts: [Shortcuts]
    
    var body: some View {
        ScrollView(.vertical) {
            VStack(spacing: 5) {
                ForEach(0..<shortcuts.count, id: \.self) { i in
                    VStack (spacing: 5) {
                        ExpandedShortcutCell(index: i+1, shortcut: shortcuts[i])
                        
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
                type.getTitleImage()
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
    let index: Int
    let shortcut: Shortcuts
    var body: some View {
        HStack(spacing: 14) {
            ZStack {
                Image("Seal")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 28)
                    .foregroundStyle(
                        fetchSealColor(index: index)
                    )
                Text("\(index)")
                    .font(.system(size: 15, weight: .medium))
                    .foregroundStyle(fetchTextColor(index: index))
                    .blendMode(fetchBlendMode(index: index))
            }
            ShortcutIcon(sfsymbol: shortcut.sfSymbol, color: shortcut.color, size: 56)
            
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
    
    private func fetchSealColor(index: Int) -> LinearGradient {
        switch index {
        case 1:
            return SCZColor.Seal.gold
        case 2:
            return SCZColor.Seal.silver
        case 3:
            return SCZColor.Seal.bronze
        case 4,5:
            return SCZColor.Seal.iron
        default:
            return SCZColor.Seal.defaultColor
            
        }
    }
    private func fetchTextColor(index: Int) ->  LinearGradient {
        switch index {
        case 1:
            return SCZColor.Seal.textGold
        case 2:
            return SCZColor.Seal.textSilver
        case 3:
            return SCZColor.Seal.textBronze
        case 4,5:
            return SCZColor.Seal.textIron
        default:
            return SCZColor.Seal.textDefault
            
        }
    }
    
    private func fetchBlendMode(index: Int) -> BlendMode {
        switch index{
        case 1, 2, 3:
            return .multiply
        case 4,5:
            return .colorBurn
        default:
            return .normal
        }
    }
}
