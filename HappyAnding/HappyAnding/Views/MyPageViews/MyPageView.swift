//
//  MyPageView.swift
//  HappyAnding
//
//  Created by 이지원 on 2022/10/19.
//

import SwiftUI

struct MyPageView: View {
    
    @EnvironmentObject var shortcutsZipViewModel: ShortcutsZipViewModel
    
    @AppStorage("useWithoutSignIn") var useWithoutSignIn: Bool = false
    
    @State var isTappedUserGradeButton = false
    
    var body: some View {
        ScrollView {
            VStack(spacing: 12) {
                
                //MARK: - 사용자 프로필
                Button {
                    //프로필 설정 페이지 연걸
                } label: {
                    HStack {
                        Image("profile_ex")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 96, height: 96)
                        
                        VStack(spacing: 9) {
                            HStack {
                                //뱃지 영역 ExploreShortcutView 머지 후 Seal 이용하기
                                Image(systemName: "seal")
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 30)
                                Image(systemName: "seal")
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 30)
                                Image(systemName: "seal")
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 30)
                                Image(systemName: "seal")
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 30)
                            }
                            .frame(maxWidth: .infinity, alignment: .leading)
                            Divider()
                            HStack {
                                Text(shortcutsZipViewModel.userInfo?.nickname ?? TextLiteral.defaultUser)
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
                
                MyPageSection(type: .myShortcut, shortcuts: $shortcutsZipViewModel.shortcutsMadeByUser)
                Divider()
                    .padding(.horizontal, 16)
                    .foregroundStyle(SCZColor.CharcoalGray.opacity08)
                MyPageSection(type: .myDownloadShortcut, shortcuts: $shortcutsZipViewModel.shortcutsUserDownloaded)
                Divider()
                    .padding(.horizontal, 16)
                    .foregroundStyle(SCZColor.CharcoalGray.opacity08)
                MyPageSection(type: .myLovingShortcut, shortcuts: $shortcutsZipViewModel.shortcutsUserLiked)
                Divider()
                    .padding(.horizontal, 16)
                    .foregroundStyle(SCZColor.CharcoalGray.opacity08)
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
    @State var isFolded = false
    
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
                }
            }
            .padding(.horizontal, 16)
            
            if type == .myShortcut || !isFolded {
                ScrollView(.horizontal, showsIndicators: false ) {
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
                            
                            ForEach(shortcuts.prefix(5), id: \.self) { shortcut in
                                OrderedCell(type: .myShortcut, index: 0, shortcut: shortcut)
                            }
                            if shortcuts.count > 5 {
                                ExpandedCell(type: type, shortcuts: shortcuts)
                            }
                        } else {
                            ForEach(shortcuts.prefix(4), id: \.self) { shortcut in
                                UnorderedCell(shortcut: shortcut)
                            }
                            if shortcuts.count > 4 {
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
