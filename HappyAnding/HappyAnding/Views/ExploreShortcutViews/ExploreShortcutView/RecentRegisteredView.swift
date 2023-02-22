//
//  RecentRegisteredView.swift
//  HappyAnding
//
//  Created by kimjimin on 2023/01/19.
//

import SwiftUI

struct RecentRegisteredView: View {
    
    @Binding var shortcuts: [Shortcuts]
    
    let navigationParentView: NavigationParentView
    
    var body: some View {
        VStack(spacing: 0) {
            HStack {
                SubtitleTextView(text: TextLiteral.recentRegisteredViewTitle)
                    .id(111)
                
                Spacer()
                
                MoreCaptionTextView(text: TextLiteral.more)
                    .navigationLinkRouter(data: NavigationListShortcutType(sectionType: .recent,
                                                                           shortcuts: shortcuts,
                                                                           navigationParentView: .shortcuts))
                
            }
            .padding(.horizontal, 16)
            .padding(.bottom, 12)
            
            ForEach(Array(shortcuts.enumerated()), id:\.offset) { index, shortcut in
                if index < 3 {
                    let data = NavigationReadShortcutType(shortcutID: shortcut.id,
                                                          navigationParentView: self.navigationParentView)
                    
                    ShortcutCell(shortcut: shortcut,
                                 navigationParentView: self.navigationParentView)
                    .navigationLinkRouter(data: data)
                }
            }
            .background(Color.shortcutsZipBackground)
        }
    }
}
