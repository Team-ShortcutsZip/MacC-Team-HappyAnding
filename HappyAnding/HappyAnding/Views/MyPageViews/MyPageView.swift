//
//  MyPageView.swift
//  HappyAnding
//
//  Created by 이지원 on 2022/10/19.
//

import SwiftUI

struct MyPageView: View {
    @StateObject var viewModel: MyPageViewModel

    var body: some View {
        ScrollView(showsIndicators: false) {
            VStack(spacing: 12) {
                Button {
                    //프로필 설정 페이지 연걸
                } label: {
                    HStack {
                        //TODO: 프로필 이미지 - 등급 시스템과 동일 추후 이미지 연결
                        Image("profile_ex")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 96, height: 96)
                        
                        VStack(spacing: 9) {
                            HStack {
                                //TODO: 추가 예정 이미지 확정되면 넣기
                            }
                            .frame(maxWidth: .infinity, alignment: .leading)
                            Divider()
                            HStack {
                                Text(viewModel.fetchUserInfo())
                                    .frame(maxWidth: .infinity, alignment: .leading)
                                    .foregroundStyle(SCZColor.Basic)
                                Image(systemName: "slider.horizontal.3")
                                    .foregroundStyle(SCZColor.CharcoalGray.opacity64)
                            }
                            .padding(.vertical, 8)
                        }
                        .padding(.vertical, 12)
                        .padding(.horizontal, 16)
                        .background(Color.white)
                        .clipShape(RoundedRectangle(cornerRadius: 16))
                        
                    }
                }
                .padding(.horizontal, 16)
                
                MyPageSection(type: .myShortcut, shortcuts: $viewModel.myShortcuts, isFolded: .constant(false))

                MyPageSection(type: .myDownloadShortcut, shortcuts: $viewModel.myDownloadShortcuts, isFolded: $viewModel.isMyDownloadShortcutFolded)
                
                if viewModel.isMyDownloadShortcutFolded {
                    Divider()
                        .padding(.horizontal, 16)
                        .foregroundStyle(SCZColor.CharcoalGray.opacity08)
                }
                
                MyPageSection(type: .myLovingShortcut, shortcuts: $viewModel.myLovingShortcuts, isFolded: $viewModel.isMyLovingShortcutFolded)
                
                if viewModel.isMyLovingShortcutFolded {
                    Divider()
                        .padding(.horizontal, 16)
                        .foregroundStyle(SCZColor.CharcoalGray.opacity08)
                }
            }
            .padding(.bottom, 30)
            .padding(.top, 12)
        }
        .toolbar{
            ToolbarItem(placement: .topBarLeading) {
                Text(TextLiteral.myPageViewTitle)
                    .font(.system(size: 24, weight: .bold))
                    .foregroundStyle(
                        LinearGradient(colors: [SCZColor.CharcoalGray.color, SCZColor.CharcoalGray.opacity48], startPoint: .top, endPoint: .bottom)
                    )
            }
            ToolbarItem(placement: .topBarTrailing) {
                HStack(spacing: 3) {
                    Button {
                        //TODO: 알림창 연결
                        print("알림창 연결")
                    } label: {
                        Image(systemName: "bell.badge.fill")
                            .symbolRenderingMode(.palette)
                            .foregroundStyle(
                                Color(hexString: "3366FF"),
                                LinearGradient(
                                    colors: [SCZColor.CharcoalGray.color, SCZColor.CharcoalGray.opacity48],
                                    startPoint: .top,
                                    endPoint: .bottom
                                )
                            )
                    }
                    Button {
                        print("설정 페이지 연결")
                    } label: {
                        Image(systemName: "gearshape.fill")
                            .foregroundStyle(
                                LinearGradient(
                                    colors: [SCZColor.CharcoalGray.color, SCZColor.CharcoalGray.opacity48],
                                    startPoint: .top,
                                    endPoint: .bottom
                                ).opacity(0.64)
                            )
//                            .navigationLinkRouter(data: NavigationSettingView.first)
                    }
                }
            }
        }
        .background(
            ZStack {
                Color.white
                SCZColor.CharcoalGray.opacity04
            }
        )
    }
}

struct MyPageSection: View {
    let type: SectionType
    @Binding var shortcuts: [Shortcuts]
    @Binding var isFolded: Bool
    var body: some View {
        
        VStack(alignment: .leading, spacing: 0) {
            HStack {
                type.fetchTitleIcon()
                Text(type.title)
                //pretendard 16 bold
                    .font(.system(size: 16, weight: .bold))
                    .foregroundStyle(SCZColor.Basic)
                Text("\(shortcuts.count)")
                //SF compact rounded 14 medium
                    .font(.system(size: 14, weight: .medium))
                    .foregroundStyle(SCZColor.CharcoalGray.opacity48)
                    .padding(EdgeInsets(top: 5, leading: 7, bottom: 5, trailing: 7))
                    .background(SCZColor.CharcoalGray.opacity08)
                    .roundedBorder(cornerRadius: 16, color: Color.white, isNormalBlend: true, opacity: 0.12)
                
                Spacer()
                
                if type != .myShortcut {
                    Button {
                        withAnimation {
                            isFolded.toggle()
                        }
                    } label: {
                        Image(systemName: isFolded ? "chevron.down" : "chevron.up")
                            .foregroundStyle(SCZColor.CharcoalGray.opacity48)
                    }
                    .frame(width: 24, height: 24)
                }
            }
            .padding(.horizontal, 16)
            let maxNum = shortcuts.count > 3 ? 2 : 3
            if type == .myShortcut || !isFolded {
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 8) {
                        Rectangle()
                            .frame(width: 16)
                            .foregroundStyle(Color.clear)
                        if type == .myShortcut {
                            Button {
                                print("단축어 작성 페이지 연결")
                            } label: {
                                Image(systemName: "plus")
                                    .foregroundStyle(Color.white)
                                    .frame(width: 36, height: 144)
                                    .background(Color(hexString: "3366FF").opacity(0.88))
                                    .roundedBorder(cornerRadius: 16, color: .white, isNormalBlend: true, opacity: 0.12)
                            }
                            
                            ForEach(shortcuts.prefix(maxNum), id: \.self) { shortcut in
                                OrderedCell(type: .myShortcut, index: 0, shortcut: shortcut)
                            }
                            if shortcuts.count > maxNum {
                                ExpandedCell(type: type, shortcuts: shortcuts)
                            }
                        } else {
                            ForEach(shortcuts.prefix(maxNum), id: \.self) { shortcut in
                                UnorderedCell(shortcut: shortcut)
                            }
                            if shortcuts.count > maxNum {
                                ExpandedCell(type: type, shortcuts: shortcuts)
                            }
                        }
                        
                    }
                    .padding(.trailing, 16)
                }
                .padding(.vertical, 8)
            }
        }
    }
}

struct MyPageShortcutListCell: View {
    var type: SectionType
    let shortcuts: [Shortcuts]
    
    var body: some View {
        HStack() {
            Text(type == .myLovingShortcut ? TextLiteral.myPageViewLikedShortcuts : TextLiteral.myPageViewDownloadedShortcuts)
                .shortcutsZipTitle2()
                .foregroundStyle(Color.gray5)
                .padding(.trailing, 9)
            Text("\(shortcuts.count)개")
                .shortcutsZipBody2()
                .foregroundStyle(Color.tagText)
                .padding(.horizontal, 12)
                .padding(.vertical, 4)
                .background(
                    RoundedRectangle(cornerRadius: 16)
                        .fill( Color.tagBackground )
                        .overlay(
                            RoundedRectangle(cornerRadius: 16)
                                .strokeBorder(Color.shortcutsZipPrimary, lineWidth: 1))
                )
            Spacer()
            Image(systemName: "chevron.forward")
                .mediumIcon()
                .foregroundStyle(Color.gray5)
            
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(.horizontal, 16)
        .navigationLinkRouter(data: self.type)
    }
}
