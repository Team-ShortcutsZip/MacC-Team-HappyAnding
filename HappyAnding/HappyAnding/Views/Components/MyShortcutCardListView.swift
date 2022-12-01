//
//  MyShortcutCardListView.swift
//  HappyAnding
//
//  Created by KiWoong Hong on 2022/10/22.
//

import SwiftUI

struct MyShortcutCardListView: View {
    
    @StateObject var writeNavigation = WriteShortcutNavigation()
    
    @State var isWriting = false
    
    var shortcuts: [Shortcuts]?
    var data: NavigationListShortcutType {
        NavigationListShortcutType(sectionType: .myShortcut,
                                   shortcuts: self.shortcuts,
                                   navigationParentView: self.navigationParentView)
    }
    
    let navigationParentView: NavigationParentView
    
    var body: some View {
        VStack {
            HStack {
                Text("내가 작성한 단축어")
                    .Title2()
                    .foregroundColor(Color.Gray5)
                    .frame(maxWidth: .infinity, alignment: .leading)
                
                Spacer()
                
                NavigationLink(value: data) {
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
                        self.isWriting = true
                    } label: {
                        AddMyShortcutCardView()
                    }
                    
                    if let shortcuts {
                        ForEach(Array((shortcuts.enumerated())), id: \.offset) { index, shortcut in
                            if index < 7 {
                                let data = NavigationReadShortcutType(shortcutID: shortcut.id,
                                                                      navigationParentView: self.navigationParentView)
                                
                                NavigationLink(value: data) {
                                    MyShortcutCardView(myShortcutIcon: shortcut.sfSymbol,
                                                       myShortcutName: shortcut.title,
                                                       myShortcutColor: shortcut.color)
                                }
                            }
                        }
                    }
                }
                .padding(.horizontal, 16)
            }
        }
        .navigationBarTitleDisplayMode(.automatic)
        .fullScreenCover(isPresented: $isWriting) {
            NavigationStack(path: $writeNavigation.navigationPath) {
                WriteShortcutTitleView(isWriting: $isWriting,
                                       isEdit: false)
            }
            .environmentObject(writeNavigation)
        }
    }
}
