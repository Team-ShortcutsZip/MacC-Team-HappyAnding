//
//  DownloadRankView.swift
//  HappyAnding
//
//  Created by KiWoong Hong on 2022/10/22.
//

import SwiftUI

struct DownloadRankView: View {
    
    @Binding var shortcuts: [Shortcuts]
    
    var body: some View {
        VStack {
            HStack {
                Text("다운로드 순위")
                    .Title2()
                    .foregroundColor(Color.Gray5)
                    .frame(maxWidth: .infinity, alignment: .leading)
                
                Spacer()
                
                NavigationLink(value: shortcuts) {
                    Text("더보기")
                        .Footnote()
                        .foregroundColor(Color.Gray4)
                        .padding(.trailing, 16)
                }
                .navigationDestination(for: [Shortcuts].self) { shortcuts in
                    ShortcutsListView(shortcuts: $shortcuts, sectionType: SectionType.download)
                        .navigationBarTitleDisplayMode(NavigationBarItem.TitleDisplayMode.inline)
                }
            }
            .padding(.leading, 16)
            
            ForEach(Array(shortcuts.enumerated()), id:\.offset) { index, shortcut in
                if index < 3 {
                    NavigationLink(value: shortcut.id) {
                        ShortcutCell(shortcut: shortcut, rankNumber: index + 1)
                    }
                }
            }
            .navigationDestination(for: String.self) { shortcutID in
                ReadShortcutView(shortcutID: shortcutID)
            }
        }
        .background(Color.Background)
    }
}
