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
    var data: NavigationListShortcutType {
        NavigationListShortcutType(sectionType: .myShortcut,
                                   shortcuts: self.shortcuts,
                                   navigationParentView: self.navigationParentView)
    }
    
    let navigationParentView: NavigationParentView
    
    var body: some View {
        VStack {
            HStack {
                SubtitleTextView(text: TextLiteral.myShortcutCardListViewTitle)
                
                Spacer()
                
                NavigationLink(value: data) {
                    MoreCaptionTextView(text: TextLiteral.more)
                }
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
                WriteShortcutView(isWriting: $isWriting, isEdit: false)
                    .onDisappear() {
                        gradeAlerter.isPresented = shortcutsZipViewModel.isShortcutUpgrade()
                    }
            }
            .environmentObject(writeNavigation)
        }
    }
}
