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
        VStack(spacing: 0) {
            HStack {
                Text(TextLiteral.lovedShortcutViewTitle)
                    .Title2()
                    .foregroundColor(Color.Gray5)
                    .frame(maxWidth: .infinity, alignment: .leading)
                
                Spacer()
                
                NavigationLink(value: NavigationListShortcutType(sectionType: .popular,
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
            
            if let shortcuts {
                ForEach(Array(shortcuts.enumerated()), id:\.offset) { index, shortcut in
                    if index < 3 {
                        let data = NavigationReadShortcutType(shortcutID: shortcut.id,
                                                              navigationParentView: .shortcuts)
                        
                        NavigationLink(value: data) {
                            ShortcutCell(shortcut: shortcut,
                                         navigationParentView: .shortcuts)
                        }
                    }
                }
            }
            
        }
        .background(Color.Background)
    }
}

