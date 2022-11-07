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
                
                NavigationLink(destination: {
                    ShortcutsListView(shortcuts: $shortcuts, sectionType: SectionType.popular)
                        .navigationBarTitleDisplayMode(NavigationBarItem.TitleDisplayMode.inline)
                }, label: {
                    Text("더보기")
                        .Footnote()
                        .foregroundColor(Color.Gray4)
                        .padding(.trailing, 16)
                })
            }
            .padding(.leading, 16)
            
            if let shortcuts {
                ForEach(Array(shortcuts.enumerated()), id:\.offset) { index, shortcut in
                    if index < 3 {
                        NavigationLink(destination: ReadShortcutView(shortcut: shortcut, shortcutID: shortcut.id), label: {
                            ShortcutCell(shortcut: shortcut)
                        })
                    }
                }
            }
            
        }
        .background(Color.Background)
    }
}

