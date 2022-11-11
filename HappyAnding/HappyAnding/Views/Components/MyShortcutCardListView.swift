//
//  MyShortcutCardListView.swift
//  HappyAnding
//
//  Created by KiWoong Hong on 2022/10/22.
//

import SwiftUI

struct MyShortcutCardListView: View {
    
    @State var isWriting = false
    
    var shortcuts: [Shortcuts]?
    
    var body: some View {
        VStack {
            HStack {
                Text("내가 등록한 단축어")
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
                    ListShortcutView(shortcuts: shortcuts, sectionType: .myShortcut)
                }
            }
            .padding(.leading, 16)
            
            ScrollView(.horizontal, showsIndicators: false) {
                HStack {
                    Button {
                        isWriting.toggle()
                    } label: {
                        AddMyShortcutCardView()
                    }
                    .fullScreenCover(isPresented: $isWriting, content: {
                        WriteShortcutTitleView(isWriting: self.$isWriting, isEdit: false)
                    })
                    
                    if let shortcuts {
                        ForEach(Array((shortcuts.enumerated())), id: \.offset) { index, shortcut in
                            if index < 7 {
                                NavigationLink(value: shortcut.id) {
                                    MyShortcutCardView(myShortcutIcon: shortcut.sfSymbol, myShortcutName: shortcut.title, myShortcutColor: shortcut.color)
                                }
                            }
                        }
                    }
                }
                .navigationDestination(for: String.self) { shortcutID in
                    ReadShortcutView(shortcutID: shortcutID)
                }
                .padding(.horizontal, 16)
            }
        }
        .navigationBarTitleDisplayMode(.automatic)
    }
}
