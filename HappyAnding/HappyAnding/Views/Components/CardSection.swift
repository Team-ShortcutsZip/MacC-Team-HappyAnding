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
    
    var body: some View {
        VStack(alignment: .leading, spacing: 6) {
            HStack {
                type.fetchTitleIcon()
                Text(type.title)
                    .foregroundStyle(SCZColor.Basic)
            }
                .font(.system(size: 20, weight: .semibold))
                .padding(.horizontal, 13)
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 6) {
                    Rectangle()
                        .foregroundStyle(Color.clear)
                        .frame(width: 13)
                    ForEach(Array(shortcuts.enumerated()).prefix(5), id: \.offset) { index, shortcut in
                        switch type {
                        case .recent:
                            UnorderedCell(shortcut: shortcut)
                        default:
                            OrderedCell(type: .download, index: index+1, shortcut: shortcut)
                        }
                    }
                    ExpandedCell(type: type, shortcuts: shortcuts)
                        .padding(.trailing, 13)
                }
            }
        }
        .padding(.vertical, 4)
    }
}
