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
                Text("나의 단축어")
                    .Title2()
                    .foregroundColor(Color.Gray5)
                .frame(maxWidth: .infinity, alignment: .leading)
                
                Spacer()
                
                NavigationLink(destination: ListShortcutView(shortcuts: shortcuts, sectionType: .myShortcut)) {
                    Text("더보기")
                        .Footnote()
                        .foregroundColor(Color.Gray4)
                        .padding(.trailing, 16)
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
                                NavigationLink(destination: {
                                    ReadShortcutView(shortcutID: shortcut.id)
                                }, label: {
                                    MyShortcutCardView(myShortcutIcon: shortcut.sfSymbol, myShortcutName: shortcut.title, myShortcutColor: shortcut.color)
                                })
                            }
                        }
                    }
                }
                .padding(.horizontal, 16)
            }
        }
        .navigationBarTitleDisplayMode(.automatic)
    }
}
