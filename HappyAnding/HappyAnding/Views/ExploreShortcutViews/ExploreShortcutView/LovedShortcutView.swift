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
                Text("사랑받는 단축어")
                    .Title2()
                    .foregroundColor(Color.Gray5)
                    .frame(maxWidth: .infinity, alignment: .leading)
                
                Spacer()
                
                NavigationLink(value: NavigationListShortcutType(sectionType: .popular,
                                                                 shortcuts: shortcuts,
                                                                 navigationParentView: .shortcuts)) {
                    Text("더보기")
                        .Footnote()
                        .foregroundColor(Color.Gray4)
                        .padding(.trailing, 16)
                }
            }
            .padding(.leading, 16)
            
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

