//
//  MyShortcutCardListView.swift
//  HappyAnding
//
//  Created by KiWoong Hong on 2022/10/22.
//

import SwiftUI

struct MyShortcutCardListView: View {
    
    @Environment(\.loginAlertKey) var loginAlerter
    @Environment(\.gradeAlertKey) var gradeAlerter
    @EnvironmentObject var shortcutsZipViewModel: ShortcutsZipViewModel
    
    @StateObject var writeNavigation = WriteShortcutNavigation()
    
    @AppStorage("useWithoutSignIn") var useWithoutSignIn: Bool = false
    
    @State var isWriting = false
    @State var isGradeAlertPresented = false
    
    var shortcuts: [Shortcuts]?
    
    let navigationParentView: NavigationParentView
    
    var body: some View {
        VStack {
            HStack {
                SubtitleTextView(text: TextLiteral.myShortcutCardListViewTitle)
                
                Spacer()
                
                MoreCaptionTextView(text: TextLiteral.more)
                    .navigationLinkRouter(data: SectionType.myShortcut)
            }
            .padding(.horizontal, 16)
            
            ScrollView(.horizontal, showsIndicators: false) {
                HStack {
                    Button {
                        if !useWithoutSignIn {
                            self.isWriting = true
                        } else {
                            loginAlerter.isPresented = true
                        }
                    } label: {
                        AddMyShortcutCardView()
                    }
                    
                    if let shortcuts {
                        ForEach(Array((shortcuts.enumerated())), id: \.offset) { index, shortcut in
                            if index < 7 {
                                let data = NavigationReadShortcutType(shortcutID: shortcut.id,
                                                                      navigationParentView: self.navigationParentView)
                                
                                MyShortcutCardView(myShortcutIcon: shortcut.sfSymbol,
                                                   myShortcutName: shortcut.title,
                                                   myShortcutColor: shortcut.color)
                                .navigationLinkRouter(data: data)
                            }
                        }
                    }
                }
                .padding(.horizontal, 16)
            }
        }
        .navigationBarTitleDisplayMode(.automatic)
        .fullScreenCover(isPresented: $isWriting) {
            NavigationRouter(content: writeShortcutView, path: $writeNavigation.navigationPath)
                .environmentObject(writeNavigation)
                .onDisappear() {
                    gradeAlerter.isPresented = shortcutsZipViewModel.isShortcutUpgrade()
                }
        }
    }
    
    @ViewBuilder
    private func writeShortcutView() -> some View {
        WriteShortcutView(isWriting: $isWriting, isEdit: false)
            .modifierNavigation()
    }
}
