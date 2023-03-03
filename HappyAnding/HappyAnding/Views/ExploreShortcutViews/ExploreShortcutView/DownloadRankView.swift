//
//  DownloadRankView.swift
//  HappyAnding
//
//  Created by KiWoong Hong on 2022/10/22.
//

import SwiftUI

struct DownloadRankView: View {
    
    @Binding var shortcuts: [Shortcuts]
    
    let navigationParentView: NavigationParentView
    
    var body: some View {
        VStack(spacing: 0) {
            HStack {
                SubtitleTextView(text: TextLiteral.downloadRankViewTitle)
                
                Spacer()
                
                MoreCaptionTextView(text: TextLiteral.more)
                    .navigationLinkRouter(data: NavigationListShortcutType(sectionType: .download,
                                                                           shortcuts: shortcuts,
                                                                           navigationParentView: .shortcuts))
            }
            .padding(.horizontal, 16)
            .padding(.bottom, 12)
            
            ForEach(Array(shortcuts.enumerated()), id:\.offset) { index, shortcut in
                if index < 3 {
                    let data = NavigationReadShortcutType(shortcutID:shortcut.id,
                                                          navigationParentView: self.navigationParentView)
                    
                    ShortcutCell(shortcut: shortcut,
                                 rankNumber: index + 1,
                                 navigationParentView: self.navigationParentView)
                    .navigationLinkRouter(data: data)
                }
            }
            .background(Color.shortcutsZipBackground)
        }
    }
}
