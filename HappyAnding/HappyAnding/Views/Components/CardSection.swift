//
//  CardSection.swift
//  HappyAnding
//
//  Created by JeonJimin on 4/2/24.
//

import SwiftUI

struct CardSection: View {
    let type: SectionType
    let shortcuts: [Shortcuts]
    let horizontalPadding: CGFloat = 16
    var body: some View {
        VStack(alignment: .leading, spacing: 6) {
            HStack {
                type.fetchTitleImage()
                Text(type.title)
                    .foregroundStyle(SCZColor.Basic)
            }
            .font(.system(size: 20, weight: .semibold))
            .padding(.horizontal, horizontalPadding)
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 6) {
                    Rectangle()
                        .foregroundStyle(Color.clear)
                        .frame(width: horizontalPadding-6)
                    ForEach(Array(shortcuts.enumerated()).prefix(5), id: \.offset) { index, shortcut in
                        switch type {
                        case .recent:
                            UnorderedCell(shortcut: shortcut)
                        default:
                            OrderedCell(type: .download, index: index+1, shortcut: shortcut)
                        }
                    }
                    ExpandedCell(type: type, shortcuts: shortcuts)
                        .padding(.trailing, horizontalPadding)
                }
            }
        }
        .padding(.vertical, 4)
    }
}
