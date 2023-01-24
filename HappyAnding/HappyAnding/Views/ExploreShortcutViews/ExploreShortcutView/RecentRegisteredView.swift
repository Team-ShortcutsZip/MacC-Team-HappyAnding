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
                
                NavigationLink(value: NavigationListShortcutType(sectionType: .recent,
                                                                 shortcuts: shortcuts,
                                                                 navigationParentView: .shortcuts)) {
                    MoreCaptionTextView(text: TextLiteral.more)
                }
            }
            .padding(.horizontal, 16)
            .padding(.bottom, 12)
            
            ForEach(Array(shortcuts.enumerated()), id:\.offset) { index, shortcut in
                if index < 3 {
                    let data = NavigationReadShortcutType(shortcutID:shortcut.id,
                                                          navigationParentView: self.navigationParentView)
                    NavigationLink(value: data) {
                        ShortcutCell(shortcut: shortcut,
                                     navigationParentView: self.navigationParentView)
                    }
                }
            }
            .background(Color.Background)
        }
    }
}
