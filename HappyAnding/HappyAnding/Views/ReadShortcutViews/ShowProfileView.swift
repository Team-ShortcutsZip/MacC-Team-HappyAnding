//
//  ShowProfileView.swift
//  HappyAnding
//
//  Created by kimjimin on 2022/11/28.
//

import SwiftUI

struct ShowProfileView: View {
    
    @StateObject var viewModel: ShowProfileViewModel
    
    @Namespace var namespace
    
    private let tabItems = [TextLiteral.showProfileViewShortcutTabTitle, TextLiteral.showProfileViewCurationTabTitle]
    
    var body: some View {
        ScrollView {
            VStack(spacing: 0) {
                StickyHeader(height: 24)
                
                //MARK: 프로필이미지 및 닉네임
                VStack(spacing: 8) {
                    Button {
                        withAnimation(.interpolatingSpring(stiffness: 10, damping: 3)) {
                            viewModel.profileDidTap()
                        }
                    } label: {
                        if viewModel.shortcuts.isEmpty {
                            viewModel.userGrade
                                .resizable()
                                .frame(width: 72, height: 72)
                                .foregroundColor(.gray3)
                        } else {
                            ZStack(alignment: .center) {
                                Circle()
                                    .frame(width: 72, height: 72)
                                    .foregroundColor(.gray1)
                                viewModel.userGrade
                                    .rotation3DEffect(
                                        .degrees(viewModel.animationAmount), axis: (x: 0.0, y: 1.0, z: 0.0))
                            }
                        }
                    }
                    
                    Text(viewModel.user.nickname)
                        .shortcutsZipTitle1()
                        .foregroundColor(.gray5)
                }
                .disabled(viewModel.shortcuts.isEmpty)
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
            withAnimation(.interpolatingSpring(stiffness: 10, damping: 3)) {
                viewModel.profileDidTap()
            }
        }
    }
    
    //MARK: 탭바
    var tabBarView: some View {
        HStack(spacing: 20) {
            ForEach(Array(zip(self.tabItems.indices, self.tabItems)), id: \.0) { index, name in
                tabBarItem(title: name, tabID: index)
            }
        }
        .padding(.horizontal, 16)
        .frame(height: 36)
        .background(Color.shortcutsZipWhite)
    }
    
    private func tabBarItem(title: String, tabID: Int) -> some View {
        Button {
            viewModel.moveTab(to: tabID)
        } label: {
            VStack {
                if viewModel.currentTab == tabID {
                    Text(title)
                        .shortcutsZipHeadline()
                        .foregroundColor(.gray5)
                    Color.gray5
                        .frame(height: 2)
                        .matchedGeometryEffect(id: "underline", in: namespace, properties: .frame)
                    
                } else {
                    Text(title)
                        .shortcutsZipBody1()
                        .foregroundColor(.gray3)
                    Color.clear
                        .frame(height: 2)
                }
            }
            .animation(.spring(), value: viewModel.currentTab)
        }
        .buttonStyle(.plain)
    }
    
    //MARK: 탭 내부 컨텐츠
    var profileContentView: some View {
        VStack {
            ZStack {
                TabView(selection: $viewModel.currentTab) {
                    Color.clear.tag(0)
                    Color.clear.tag(1)
                }
                .frame(minHeight: UIScreen.screenHeight / 2)
                .tabViewStyle(.page(indexDisplayMode: .never))
                
                switch(viewModel.currentTab) {
                case 0:
                    if viewModel.shortcuts.isEmpty {
                        VStack {
                            Text(TextLiteral.showProfileViewNoShortcuts)
                                .padding(.top, 16)
                                .shortcutsZipBody2()
                                .foregroundColor(.gray4)
                            Spacer()
                        }
                    }
                    
                    VStack(spacing: 0) {
                        ForEach(viewModel.shortcuts, id:\.self) { shortcut in
                            ShortcutCell(shortcut: shortcut,
                                         navigationParentView: .shortcuts)
                            .navigationLinkRouter(data: shortcut)
                        }
                        
                        Spacer()
                            .frame(maxHeight: .infinity)
                    }
                    .padding(.bottom, 44)
                case 1:
                    if viewModel.curations.isEmpty {
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
                            // TODO: navigation parent view 삭제
                            UserCurationCell(curation: curation,
                                             lineLimit: 2,
                                             navigationParentView: .curations)
                            .navigationLinkRouter(data: curation)
                        }
                        
                        Spacer()
                    }
                    .padding(.bottom, 44)
                default:
                    EmptyView()
                }
            }
            .animation(.easeInOut, value: viewModel.currentTab)
        }
    }
}
