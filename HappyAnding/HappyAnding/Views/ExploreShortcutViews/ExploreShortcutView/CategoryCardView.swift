//
//  CategoryCardView.swift
//  HappyAnding
//
//  Created by kimjimin on 2022/11/22.
//

import SwiftUI

struct CategoryCardView: View {
    
    @EnvironmentObject var shortcutsZipViewModel: ShortcutsZipViewModel
    @Binding var shortcuts: [Shortcuts]
    let categoryName: Category
    let navigationParentView: NavigationParentView
    
    var body: some View {
        VStack(spacing: 0) {
            HStack {
                SubtitleTextView(text: categoryName.translateName())
                
                Spacer()
                
                NavigationLink(value: categoryName) {
                    MoreCaptionTextView(text: TextLiteral.more)
                }
            }
            .padding(.horizontal, 16)
            .padding(.bottom, 12)
            
            ScrollView(.horizontal, showsIndicators: false) {
                HStack {
                    if let shortcuts {
                        ForEach(Array((shortcuts.enumerated())), id: \.offset) { index, shortcut in
                            if index < 7 {
                                let data = NavigationReadShortcutType(shortcutID: shortcut.id,
                                                                      navigationParentView: self.navigationParentView)
                                
                                NavigationLink(value: data) {
                                    ShortcutCardCell(categoryShortcutIcon: shortcut.sfSymbol,
                                                     categoryShortcutName: shortcut.title,
                                                     categoryShortcutColor: shortcut.color)
                                }
                            }
                        }
                    }
                }
                .padding(.horizontal, 16)
            }
        }
    }
}
