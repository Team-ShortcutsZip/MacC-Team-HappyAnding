//
//  MyShortcutCardListView.swift
//  HappyAnding
//
//  Created by KiWoong Hong on 2022/10/22.
//

import SwiftUI

struct MyShortcutCardListView: View {
    
    @StateObject var writeNavigation = WriteShortcutNavigation()
    @AppStorage("useWithoutSignIn") var useWithoutSignIn: Bool = false
    
    @State var isWriting = false
    @State private var tryWriteWithoutSignIn: Bool = false
    
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
                SubtitleTextView(text: "내가 작성한 단축어")
                
                Spacer()
                
                NavigationLink(value: data) {
                    MoreCaptionTextView(text: "더보기")
                }
            }
            .padding(.horizontal, 16)
            
            ScrollView(.horizontal, showsIndicators: false) {
                HStack {
                    Button {
                        if !useWithoutSignIn {
                            self.isWriting = true
                        } else {
                            self.tryWriteWithoutSignIn = true
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
        .alert("로그인을 진행해주세요", isPresented: $tryWriteWithoutSignIn) {
            Button(role: .cancel) {
                tryWriteWithoutSignIn = false
            } label: {
                Text("취소")
            }
            Button {
                useWithoutSignIn = false
                tryWriteWithoutSignIn = false
            } label: {
                Text("로그인하기")
            }
        } message: {
            Text("이 기능은 로그인 후 사용할 수 있어요")
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
