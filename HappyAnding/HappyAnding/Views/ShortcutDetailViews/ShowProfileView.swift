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
    @Namespace var namespace
    @State var currentTab: Int = 0
    private let tabItems = ["작성한 단축어", "작성한 큐레이션"]
    
    var body: some View {
        ScrollView {
            VStack(spacing: 0) {
                GeometryReader { geo in
                    let yOffset = geo.frame(in: .global).minY
                    
                    Color.White
                        .frame(width: geo.size.width, height: 40 + (yOffset > 0 ? yOffset : 0))
                        .offset(y: yOffset > 0 ? -yOffset : 0)
                }
                
                //MARK: 프로필이미지 및 닉네임
                VStack {
                    Circle()
                        .fill(Color.Gray4)
                        .frame(width: 72, height: 72)
                    Text(data.userInfo?.nickname ?? "user")
                        .Title1()
                        .foregroundColor(.Gray5)
                }
                .frame(maxWidth: .infinity)
                .frame(height: 160)
                .background(Color.White)
                
                //MARK: 탭바 및 탭 내부 컨텐츠
                LazyVStack(pinnedViews: [.sectionHeaders]) {
                    Section(header: tabBarView) {
                        profileContentView
                            .padding(.top, 12)
                    }
                }
            }
        }
        .navigationBarBackground { Color.White }
        .background(Color.Background)
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
        .background(Color.White)
    }
    
    private func tabBarItem(string: String, tab: Int) -> some View {
        Button {
            self.currentTab = tab
        } label: {
            VStack {
                if self.currentTab == tab {
                    Text(string)
                        .Headline()
                        .foregroundColor(.Gray5)
                    Color.Gray5
                        .frame(height: 2)
                        .matchedGeometryEffect(id: "underline", in: namespace, properties: .frame)
                    
                } else {
                    Text(string)
                        .Body1()
                        .foregroundColor(.Gray3)
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
                .tabViewStyle(.page(indexDisplayMode: .never))
                
                switch(currentTab) {
                case 0:
                    if shortcuts.isEmpty {
                        Text("작성한 단축어가 없습니다.")
                            .padding(.top, 24)
                            .Body2()
                            .foregroundColor(.Gray4)
                    } else {
                        VStack(spacing: 0) {
                            ForEach(Array(shortcuts.enumerated()), id:\.offset) { index, shortcut in
                                let data = NavigationReadShortcutType(shortcutID:shortcut.id,
                                                                      navigationParentView: .shortcuts)
                                NavigationLink(value: data) {
                                    ShortcutCell(shortcut: shortcut,
                                                 navigationParentView: data.navigationParentView)
                                }
                            }
                            
                            Spacer()
                        }
                    }
                case 1:
                    if curations.isEmpty {
                        
                        // TODO: 큐레이션에 대한 워딩 변경
                        Text("작성한 큐레이션이 없습니다.")
                            .padding(.top, 24)
                            .Body2()
                            .foregroundColor(.Gray4)
                    }
                    VStack(spacing: 0) {
                        ForEach(Array(curations.enumerated()), id: \.offset) { index, curation in
                            let data = NavigationReadUserCurationType(userCuration: curation,
                                                                      navigationParentView: .shortcuts)
                            NavigationLink(value: data) {
                                UserCurationCell(curation: curation,
                                                 navigationParentView: data.navigationParentView)
                            }
                        }
                        
                        Spacer()
                    }
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
