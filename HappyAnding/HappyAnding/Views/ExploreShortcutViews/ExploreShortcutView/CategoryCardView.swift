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
                
                MoreCaptionTextView(text: TextLiteral.more)
                    .navigationLinkRouter(data: NavigationListCategoryShortcutType(shortcuts: [],
                                                                                   categoryName: categoryName,
                                                                                   navigationParentView: navigationParentView))
            }
            .padding(.horizontal, 16)
            .padding(.bottom, 12)
            
            ScrollView(.horizontal, showsIndicators: false) {
                HStack {
                    ForEach(Array((shortcuts.enumerated())), id: \.offset) { index, shortcut in
                        if index < 7 {
                            let data = NavigationReadShortcutType(
                                shortcutID: shortcut.id,
                                navigationParentView: self.navigationParentView)
                            
                            ShortcutCardCell(
                                categoryShortcutIcon: shortcut.sfSymbol,
                                categoryShortcutName: shortcut.title,
                                categoryShortcutColor: shortcut.color)
                            .navigationLinkRouter(data: data)
                        }
                    }
                }
                .padding(.horizontal, 16)
            }
        }
    }
}
