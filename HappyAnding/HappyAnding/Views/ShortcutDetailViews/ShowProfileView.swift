//
//  ShowProfileView.swift
//  HappyAnding
//
//  Created by kimjimin on 2022/11/28.
//

import SwiftUI

struct ShowProfileView: View {
    
    @EnvironmentObject var shortcutsZipViewModel: ShortcutsZipViewModel
    
    @State var shortcuts: [Shortcuts] = []
    @State var curations: [Curation] = []
    @Namespace var namespace
    @State var currentTab: Int = 0
    @State var height: CGFloat = UIScreen.screenHeight / 2
    private let contentSize = UIScreen.screenHeight / 2
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
                
                VStack {
                    // 프로필 이미지
                    Circle()
                        .fill(Color.Gray4)
                        .frame(width: 72, height: 72)
                    Text("닉네임")
                        .Title1()
                        .foregroundColor(.Gray5)
                }
                .frame(maxWidth: .infinity)
                .frame(height: 160)
                .background(Color.White)
                
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
            
            //TODO: - author가 작성한 shortcuts, curations만 불러오기
            
            shortcuts = shortcutsZipViewModel.allShortcuts
            curations = shortcutsZipViewModel.fetchCurationByAuthor(author: "")
        }
    }
}

extension ShowProfileView {
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
    
    var profileContentView: some View {
        VStack {
            ZStack {
                TabView(selection: self.$currentTab) {
                    Color.clear.tag(0)
                    Color.clear.tag(1)
                }
                .tabViewStyle(.page(indexDisplayMode: .never))
                .frame(height: height)
                
                switch(currentTab) {
                case 0:
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
                    .background(
                        GeometryReader { geometryProxy in
                            Color.clear
                                .preference(key: SizePreferenceKey.self,
                                            value: geometryProxy.size)
                        })
                case 1:
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
                    .background(
                        GeometryReader { geometryProxy in
                            Color.clear
                                .preference(key: SizePreferenceKey.self,
                                            value: geometryProxy.size)
                        })
                default:
                    EmptyView()
                }
            }
            .animation(.easeInOut, value: currentTab)
            .onPreferenceChange(SizePreferenceKey.self) { newSize in
                self.height = contentSize > newSize.height ? contentSize : newSize.height
            }
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
