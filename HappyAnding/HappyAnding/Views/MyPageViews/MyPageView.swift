//
//  MyPageView.swift
//  HappyAnding
//
//  Created by 이지원 on 2022/10/19.
//

import SwiftUI

struct MyPageView: View {
    
    @EnvironmentObject var shortcutsZipViewModel: ShortcutsZipViewModel
    @StateObject var navigation = ProfileNavigation()
    
    var body: some View {
        NavigationStack(path: $navigation.navigationPath) {
            ScrollView {
                VStack(spacing: 32) {
                    
                    //MARK: - 사용자 프로필
                    
                    HStack(spacing: 16) {

                        //TODO: 사용되는 임시 이미지 지정되면 변경 필요
                        
                        Image(systemName: "person.fill")
                            .font(.title)
                            .frame(width: 60, height: 60)
                            .foregroundColor(.White)
                            .background(Color.Gray3)
                            .clipShape(Circle())
                            HStack {
                                Text(shortcutsZipViewModel.userInfo?.nickname ?? "User")
                                    .Title1()
                                    .foregroundColor(.Gray5)
                                //TODO: 스프린트 1에서 배제 추후 주석 삭제 필요
                                /*
                                Image(systemName: "square.and.pencil")
                                    .Title2()
                                    .foregroundColor(.Gray4)
                                 */
                            }
                        Spacer()
                    }
                    .frame(maxWidth: .infinity)
                    .padding(.horizontal, 16)
                    .padding(.top, 35)
                    
                    //TODO: - 각 뷰에 해당하는 단축어 목록 전달하도록 변경 필요
                    
                    // MARK: - 나의 단축어
                    
                    MyShortcutCardListView(isAccessExploreShortcut: false,
                                           shortcuts: shortcutsZipViewModel.shortcutsMadeByUser)
                    
                    // MARK: - 나의 큐레이션
                    
                    UserCurationListView(data: NavigationCurationType(type: .userCuration,
                                                                      title: "내가 작성한 큐레이션",
                                                                      isAccessCuration: true),
                                         userCurations: $shortcutsZipViewModel.curationsMadeByUser)
                        .frame(maxWidth: .infinity)
                    
                    // MARK: - 좋아요한 단축어
                    
                    MyPageShortcutList(
                        shortcuts: shortcutsZipViewModel.shortcutsUserLiked,
                        type: .myLovingShortcut
                    )
                    
                    // MARK: -다운로드한 단축어
                    
                    MyPageShortcutList(
                        shortcuts: shortcutsZipViewModel.shortcutsUserDownloaded,
                        type: .myDownloadShortcut
                    )
                    .padding(.bottom, 44)
                }
            }
            .navigationBarTitle("프로필")
            .navigationBarTitleDisplayMode(.large)
            .toolbar {
                ToolbarItem {
                    NavigationLink(value: 0) {
                        Image(systemName: "gearshape.fill")
                            .Headline()
                            .foregroundColor(.Gray5)
                    }
                }
            }
            .scrollIndicators(.hidden)
            .background(Color.Background)
            .navigationDestination(for: Int.self) { _ in
                SettingView()
            }
        }
        .environmentObject(navigation)
    }
}

struct MyPageShortcutList: View {
    @EnvironmentObject var navigation: ProfileNavigation
    
    var shortcuts: [Shortcuts]?
    var type: SectionType
    var body: some View {
        VStack(spacing: 0) {
            MyPageListHeader(type: type, shortcuts: shortcuts)
                .padding(.horizontal, 16)
            if let shortcuts {
                ForEach(Array(shortcuts.enumerated()), id: \.offset) { index, shortcut in
                    if index < 3 {
                        NavigationLink(value: shortcut) {
                            ShortcutCell(shortcut: shortcut)
                        }
                    }
                }
            }
        }
        .navigationDestination(for: Shortcuts.self) { shortcut in
            ReadShortcutView(shortcutID: shortcut.id)
        }
        .navigationDestination(for: SectionType.self) { type in
            ListShortcutView(data: NavigationListShortcutType(sectionType: type,
                                                              shortcuts: self.shortcuts))
        }
        .environmentObject(navigation)
    }
}

struct MyPageListHeader: View {
    @EnvironmentObject var navigation: ProfileNavigation

    var type: SectionType
    let shortcuts: [Shortcuts]?
    var data: NavigationListShortcutType {
        NavigationListShortcutType(sectionType: self.type,
                                   shortcuts: self.shortcuts)
    }
    var body: some View {
        HStack(alignment: .bottom) {
            Text(type.rawValue)
                .Title2()
                .foregroundColor(.Gray5)
                .onTapGesture { }
            Spacer()
            
            NavigationLink(value: data) {
                Text("더보기")
                    .Footnote()
                    .foregroundColor(.Gray4)
            }
        }
        .navigationDestination(for: NavigationListShortcutType.self) { data in
            ListShortcutView(data: data)
        }
        .environmentObject(navigation)
    }
}

