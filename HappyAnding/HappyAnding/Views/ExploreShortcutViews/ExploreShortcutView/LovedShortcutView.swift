//
//  LovedShortcutView.swift
//  HappyAnding
//
//  Created by KiWoong Hong on 2022/10/22.
//

import SwiftUI

struct LovedShortcutView: View {
    
    @Binding var shortcuts: [Shortcuts]
    
    var body: some View {
        VStack {
            HStack {
                Text("사랑받는 단축어")
                    .Title2()
                    .foregroundColor(Color.Gray5)
                    .frame(maxWidth: .infinity, alignment: .leading)
                
                Spacer()
                
                NavigationLink(value: SectionType.popular) {
                    Text("더보기")
                        .Footnote()
                        .foregroundColor(Color.Gray4)
                        .padding(.trailing, 16)
                }
                .navigationDestination(for: SectionType.self, destination: { type in
                    ShortcutsListView(shortcuts: $shortcuts,
                                      sectionType: type,
                                      navigationParentView: .shortcuts)
                })
            }
            .padding(.leading, 16)
            
            if let shortcuts {
                ForEach(Array(shortcuts.enumerated()), id:\.offset) { index, shortcut in
                    if index < 3 {
                        NavigationLink(value: shortcut.id) {
                            ShortcutCell(shortcut: shortcut,
                                         navigationParentView: .shortcuts)
                            .navigationDestination(for: String.self, destination: { shortcutID in
                                ReadShortcutView(shortcutID: shortcutID,
                                                 navigationParentView: .shortcuts)
                            })
                        }
                    }
                }
            }
            
        }
//        .environmentObject(navigation)
        .background(Color.Background)
    }
}

