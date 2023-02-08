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
                Text(TextLiteral.recentRegisteredViewTitle)
                    .Title2()
                    .foregroundColor(Color.Gray5)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .id(111)
                
                Spacer()
                
                NavigationLink(value: NavigationListShortcutType(sectionType: .recent,
                                                                 shortcuts: shortcuts,
                                                                 navigationParentView: .shortcuts)) {
                    Text(TextLiteral.more)
                        .Footnote()
                        .foregroundColor(Color.Gray4)
                        .padding(.trailing, 16)
                }
            }
            .padding(.leading, 16)
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
