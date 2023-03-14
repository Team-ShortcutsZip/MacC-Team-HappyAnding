//
//  ShowProfileView.swift
//  HappyAnding
//
//  Created by kimjimin on 2022/11/28.
//

import SwiftUI

struct ShowProfileView: View {
    
    @EnvironmentObject var shortcutsZipViewModel: ShortcutsZipViewModel
    
    @State var data: NavigationProfile
    
    @State var shortcuts: [Shortcuts] = []
    @State var curations: [Curation] = []
    @State var currentTab: Int = 0
    
    @Namespace var namespace
    
    private let tabItems = [TextLiteral.showProfileViewShortcutTabTitle, TextLiteral.showProfileViewCurationTabTitle]
    
    var body: some View {
        ScrollView {
            VStack(spacing: 0) {
                
                StickyHeader(height: 24)
                
                //MARK: 프로필이미지 및 닉네임
                VStack(spacing: 8) {
                    ZStack(alignment: .center) {
                        Circle()
                            .frame(width: 72, height: 72)
                            .foregroundColor(.gray1)
                        shortcutsZipViewModel.fetchShortcutGradeImage(isBig: true, shortcutGrade: shortcutsZipViewModel.checkShortcutGrade(userID: data.userInfo?.id ?? ""))
                            .font(.system(size: 72, weight: .medium))
                            .foregroundColor(.gray3)
                    }
                    Text(data.userInfo?.nickname ?? TextLiteral.defaultUser)
                        .shortcutsZipTitle1()
                        .foregroundColor(.gray5)
                }
                .frame(maxWidth: .infinity)
                .padding(.bottom, 35)
                .background(Color.shortcutsZipWhite)
                
                //MARK: 탭바 및 탭 내부 컨텐츠
                LazyVStack(pinnedViews: [.sectionHeaders]) {
                    Section(header: tabBarView) {
                        profileContentView
                            .padding(.top, 12)
                    }
                }
            }
        }
        .navigationBarBackground { Color.shortcutsZipWhite }
        .background(Color.shortcutsZipBackground)
        .toolbar(.visible, for: .tabBar)
        .onAppear {
            shortcuts = shortcutsZipViewModel.allShortcuts.filter { $0.author == self.data.userInfo?.id }
            curations = shortcutsZipViewModel.fetchCurationByAuthor(author: data.userInfo?.id ?? "")
        }
    }
}

extension ShowProfileView {
    
    //MARK: 탭바
    var tabBarView: some View {
        HStack(spacing: 20) {
            ForEach(Array(zip(self.tabItems.indices, self.tabItems)), id: \.0) { index, name in
                tabBarItem(string: name, tab: index)
            }
        }
        .padding(.horizontal, 16)
        .frame(height: 36)
        .background(Color.shortcutsZipWhite)
    }
    
    private func tabBarItem(string: String, tab: Int) -> some View {
        Button {
            self.currentTab = tab
        } label: {
            VStack {
                if self.currentTab == tab {
                    Text(string)
                        .shortcutsZipHeadline()
                        .foregroundColor(.gray5)
                    Color.gray5
                        .frame(height: 2)
                        .matchedGeometryEffect(id: "underline", in: namespace, properties: .frame)
                    
                } else {
                    Text(string)
                        .shortcutsZipBody1()
                        .foregroundColor(.gray3)
                    Color.clear
                        .frame(height: 2)
                }
            }
            .animation(.spring(), value: currentTab)
        }
        .buttonStyle(.plain)
    }
    
    //MARK: 탭 내부 컨텐츠
    var profileContentView: some View {
        VStack {
            ZStack {
                TabView(selection: self.$currentTab) {
                    Color.clear.tag(0)
                    Color.clear.tag(1)
                }
                .frame(minHeight: UIScreen.screenHeight / 2)
                .tabViewStyle(.page(indexDisplayMode: .never))
                
                switch(currentTab) {
                case 0:
                    if shortcuts.isEmpty {
                        VStack {
                            Text(TextLiteral.showProfileViewNoShortcuts)
                                .padding(.top, 16)
                                .shortcutsZipBody2()
                                .foregroundColor(.gray4)
                            Spacer()
                        }
                    }
                    
                    VStack(spacing: 0) {
                        ForEach(shortcuts, id:\.self) { shortcut in
                            let data = NavigationReadShortcutType(shortcutID:shortcut.id,
                                                                  navigationParentView: .shortcuts)
                            
                            ShortcutCell(shortcut: shortcut,
                                         navigationParentView: data.navigationParentView)
                            .navigationLinkRouter(data: data)
                        }
                        
                        Spacer()
                            .frame(maxHeight: .infinity)
                    }
                    .padding(.bottom, 44)
                case 1:
                    if curations.isEmpty {
                        VStack{
                            Text(TextLiteral.showProfileViewNoCurations)
                                .padding(.top, 16)
                                .shortcutsZipBody2()
                                .foregroundColor(.gray4)
                            Spacer()
                        }
                    }
                    
                    VStack(spacing: 0) {
                        ForEach(curations, id: \.self) { curation in
                            let data = NavigationReadUserCurationType(userCuration: curation,
                                                                      navigationParentView: .shortcuts)
                            UserCurationCell(curation: curation,
                                             lineLimit: 2,
                                             navigationParentView: data.navigationParentView)
                            .navigationLinkRouter(data: data)
                        }
                        
                        Spacer()
                    }
                    .padding(.bottom, 44)
                default:
                    EmptyView()
                }
            }
            .animation(.easeInOut, value: currentTab)
            .gesture(
                DragGesture(minimumDistance: 20, coordinateSpace: .global)
                    .onEnded { value in
                        let horizontalAmount = value.translation.width
                        let verticalAmount = value.translation.height
                        
                        if abs(horizontalAmount) > abs(verticalAmount) {
                            if horizontalAmount < 0 {
                                currentTab += 1
                            } else {
                                currentTab -= 1
                            }
                        }
                    }
            )
        }
    }
}
