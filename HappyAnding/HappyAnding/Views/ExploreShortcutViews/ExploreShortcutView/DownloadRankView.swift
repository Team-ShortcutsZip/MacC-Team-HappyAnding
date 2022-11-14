//
//  DownloadRankView.swift
//  HappyAnding
//
//  Created by KiWoong Hong on 2022/10/22.
//

import SwiftUI

struct DownloadRankView: View {
    
    @EnvironmentObject var navigation: ShortcutNavigation
    @Binding var shortcuts: [Shortcuts]
    
    let navigationParentView: NavigationParentView
    
    var body: some View {
        VStack {
            HStack {
                Text("다운로드 순위")
                    .Title2()
                    .foregroundColor(Color.Gray5)
                    .frame(maxWidth: .infinity, alignment: .leading)
                
                Spacer()
                
                NavigationLink(value: SectionType.download) {
                    Text("더보기")
                        .Footnote()
                        .foregroundColor(Color.Gray4)
                        .padding(.trailing, 16)
                }
                .navigationDestination(for: SectionType.self, destination: { type in
                    ShortcutsListView(shortcuts: $shortcuts,
                                      sectionType: type,
                                      navigationParentView: self.navigation)
                })
            }
            .padding(.leading, 16)
            
            ForEach(Array(shortcuts.enumerated()), id:\.offset) { index, shortcut in
                if index < 3 {
                    NavigationLink(value: shortcut.id) {
                        ShortcutCell(shortcut: shortcut,
                                     rankNumber: index + 1,
                                     navigationParentView: self.navigationParentView)
                    }
                    .navigationDestination(for: String.self, destination: { shortcutID in
                        ReadShortcutView(shortcutID: shortcutID,
                                         navigationParentView: self.navigationParentView)
                    })
                }
            }
            .environmentObject(navigation)
            .background(Color.Background)
        }
    }
}
