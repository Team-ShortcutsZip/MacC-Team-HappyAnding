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
            VStack(spacing: 32) {
                
                //MARK: - 사용자 프로필
                
                HStack(spacing: 16) {
                    
                    Button {
                        isTappedUserGradeButton = true
                    } label: {
                        shortcutsZipViewModel.fetchShortcutGradeImage(isBig: true, shortcutGrade: shortcutsZipViewModel.checkShortcutGrade(userID: shortcutsZipViewModel.userInfo?.id ?? "!"))
                            .font(.system(size: 60, weight: .medium))
                            .frame(width: 60, height: 60)
                            .foregroundColor(.gray3)
                            .id(333)
                    }
                    
                    HStack {
                        Text(shortcutsZipViewModel.userInfo?.nickname ?? TextLiteral.defaultUser)
                            .shortcutsZipTitle1()
                            .foregroundColor(.gray5)
                        
                        if !useWithoutSignIn {
                            Image(systemName: "square.and.pencil")
                                .mediumIcon()
                                .foregroundColor(.gray4)
                                .navigationLinkRouter(data: NavigationNicknameView.first)
                        }
                    }
                    Spacer()
                }
                .frame(maxWidth: .infinity)
                .padding(.horizontal, 16)
                .padding(.top, 16)
                
                //TODO: - 각 뷰에 해당하는 단축어 목록 전달하도록 변경 필요
                
                // MARK: - 나의 단축어
                
                MyShortcutCardListView(shortcuts: shortcutsZipViewModel.shortcutsMadeByUser,
                                       navigationParentView: .myPage)
                
                // MARK: - 내가 작성한 큐레이션
                
                UserCurationListView(data: NavigationListCurationType(type: .myCuration,
                                                                      title: TextLiteral.myPageViewMyCuration,
                                                                      isAllUser: false,
                                                                      navigationParentView: .myPage,
                                                                      curation: shortcutsZipViewModel.curationsMadeByUser))
                .frame(maxWidth: .infinity)
                
                // MARK: - 좋아요한 단축어
                
                MyPageShortcutListCell(type: .myLovingShortcut, shortcuts: shortcutsZipViewModel.shortcutsUserLiked)
                
                // MARK: -다운로드한 단축어
                
                MyPageShortcutListCell(type: .myDownloadShortcut, shortcuts: shortcutsZipViewModel.shortcutsUserDownloaded)
                    .padding(.bottom, 44)
            }
        }
        .navigationBarTitle(TextLiteral.myPageViewTitle)
        .navigationBarTitleDisplayMode(.large)
        .toolbar {
            ToolbarItem {
                Image(systemName: "gearshape.fill")
                    .shortcutsZipHeadline()
                    .foregroundColor(.gray5)
                    .navigationLinkRouter(data: NavigationSettingView.first)
            }
        }
        .sheet(isPresented: $isTappedUserGradeButton) {
            AboutShortcutGradeView()
                .presentationDetents([.large])
                .presentationDragIndicator(.visible)
        }
        .scrollIndicators(.hidden)
        .background(Color.shortcutsZipBackground)
    }
}

struct MyPageShortcutListCell: View {
    var type: SectionType
    let shortcuts: [Shortcuts]
    
    var data: NavigationListShortcutType {
        NavigationListShortcutType(sectionType: self.type,
                                   shortcuts: self.shortcuts,
                                   navigationParentView: .myPage)
    }
    var body: some View {
        HStack() {
            Text(type == .myLovingShortcut ? TextLiteral.myPageViewLikedShortcuts : TextLiteral.myPageViewDownloadedShortcuts)
                .shortcutsZipTitle2()
                .foregroundColor(.gray5)
                .padding(.trailing, 9)
            Text("\(shortcuts.count)개")
                .shortcutsZipBody2()
                .foregroundColor(Color.tagText)
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
                .foregroundColor(.gray5)
            
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(.horizontal, 16)
        .navigationLinkRouter(data: data)
    }
}
