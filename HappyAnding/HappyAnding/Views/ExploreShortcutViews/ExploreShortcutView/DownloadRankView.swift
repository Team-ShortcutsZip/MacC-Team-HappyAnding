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
                Text("다운로드 순위")
                    .Title2()
                    .foregroundColor(Color.Gray5)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .id(111)
                
                Spacer()
                
                NavigationLink(value: NavigationListShortcutType(sectionType: .download,
                                                          shortcuts: shortcuts,
                                                          navigationParentView: .shortcuts)) {
                    Text("더보기")
                        .Footnote()
                        .foregroundColor(Color.Gray4)
                        .padding(.trailing, 16)
                }
            }
            .padding(.leading, 16)
            
            ForEach(Array(shortcuts.enumerated()), id:\.offset) { index, shortcut in
                if index < 3 {
                    let data = NavigationReadShortcutType(shortcutID:shortcut.id,
                                                          navigationParentView: self.navigationParentView)
                    NavigationLink(value: data) {
                        ShortcutCell(shortcut: shortcut,
                                     rankNumber: index + 1,
                                     navigationParentView: self.navigationParentView)
                    }
                }
            }
            .background(Color.Background)
        }
        .navigationDestination(for: NavigationReadShortcutType.self) { data in
            ReadShortcutView(data: data)
        }
        .navigationDestination(for: NavigationListShortcutType.self) { data in
            ListShortcutView(data: data)
        }
    }
}
