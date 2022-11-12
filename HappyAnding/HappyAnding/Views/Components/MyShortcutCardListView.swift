//
//  MyShortcutCardListView.swift
//  HappyAnding
//
//  Created by KiWoong Hong on 2022/10/22.
//

import SwiftUI

struct MyShortcutCardListView: View {
    
    @EnvironmentObject var profileNavigation: ProfileNavigation
    @EnvironmentObject var shortcutsNavigation: ShortcutNavigation
    
    let isAccessExploreShortcut: Bool
    
    var shortcuts: [Shortcuts]?
    var data: NavigationListShortcutType {
        NavigationListShortcutType(sectionType: .myShortcut,
                                   shortcuts: self.shortcuts)
    }
    
    var body: some View {
        VStack {
            HStack {
                Text("내가 등록한 단축어")
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
                .navigationDestination(for: NavigationListShortcutType.self) { data in
                    ListShortcutView(data: data)
                }
            }
            .padding(.leading, 16)
            
            ScrollView(.horizontal, showsIndicators: false) {
                HStack {
                    NavigationLink(value: false) {
                        AddMyShortcutCardView()
                    }
                    
                    if let shortcuts {
                        ForEach(Array((shortcuts.enumerated())), id: \.offset) { index, shortcut in
                            if index < 7 {
                                NavigationLink(value: shortcut.id) {
                                    MyShortcutCardView(myShortcutIcon: shortcut.sfSymbol,
                                                       myShortcutName: shortcut.title,
                                                       myShortcutColor: shortcut.color)
                                }
                            }
                        }
                    }
                }
                .navigationDestination(for: Bool.self) { isEdit in
                    WriteShortcutTitleView(isEdit: isEdit,
                                           isAccessExploreShortcut: self.isAccessExploreShortcut)
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
