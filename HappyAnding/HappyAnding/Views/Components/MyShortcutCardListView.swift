//
//  MyShortcutCardListView.swift
//  HappyAnding
//
//  Created by KiWoong Hong on 2022/10/22.
//

import SwiftUI

struct MyShortcutCardListView: View {
    
    @State var isWriting = false
//    let shortcuts = Shortcut.fetchData(number: 15)
    var shortcuts: [Shortcuts]?
    var body: some View {
        VStack {
            HStack {
                Text("내 단축어")
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
                        WriteShortcutTitleView(isWriting: self.$isWriting)
                    })

//                    NavigationLink(destination: {
//                        WriteShortcutTitleView(isWriting: $isWriting)
//                    }, label: {
//                        
//                    })
//                    .fullScreenCover(isPresented: $isWriting, content: {
//                        WriteShortcutTitleView(isWriting: self.$isWriting)
//                    })
                    
                    if let shortcuts {
                        ForEach(Array((shortcuts.enumerated())), id: \.offset) { index, shortcut in
                            if index < 7 {
                                NavigationLink(destination: {
                                    ReadShortcutView(shortcut: shortcut)
                                }, label: {
                                    MyShortcutCardView(myShortcutIcon: shortcut.sfSymbol, myShortcutName: shortcut.title, mySHortcutColor: shortcut.color)
                                })
                            }
                        }
                    }
                }
                .padding(.horizontal, 16)
            }
        }
        .navigationBarTitleDisplayMode(.inline)
    }
}
