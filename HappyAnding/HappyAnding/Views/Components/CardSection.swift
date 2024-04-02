//
//  CardSection.swift
//  HappyAnding
//
//  Created by JeonJimin on 4/2/24.
//

import SwiftUI

struct CardSection: View {
    let type: ExploreShortcutSectionType
    let shortcuts: [Shortcuts]
    
    var body: some View {
        VStack(alignment: .leading, spacing: 6) {
            type.getTitleView()
                .font(.system(size: 20, weight: .semibold))
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 6) {
                    ForEach(Array(shortcuts.enumerated()).prefix(5), id: \.offset) { index, shortcut in
                        switch type {
                        case .new:
                            UnorderedCell(shortcut: shortcut)
                        default:
                            OrderedCell(shortcut: shortcut, index: index)
                        }
                    }
                    ExpandButton
                }
            }
        }
        .padding(.horizontal, 13)
        .padding(.vertical, 4)
    }
    var ExpandButton: some View {
        Button{
            print("더보기 연결")
        }label: {
            VStack(alignment: .center, spacing: 4) {
                Image(systemName: "rectangle.portrait.on.rectangle.portrait.angled.fill")
                Text("더보기")
            }
            .foregroundStyle(Color.white.opacity(0.88))
            .font(.system(size: 15, weight: .semibold))
            .frame(width: 108, height: 144, alignment: .center)
            .background(SCZColor.CharcoalGray.opacity08)
            .cornerRadius(12)
            .overlay(
                RoundedRectangle(cornerRadius: 12)
                    .strokeBorder(Color.white.opacity(0.12), lineWidth: 2)
            )
            .shadow(color: Color(hexString: "404040", opacity: 0.04), radius: 4, x: 0, y: 2)
        }
    }
}
