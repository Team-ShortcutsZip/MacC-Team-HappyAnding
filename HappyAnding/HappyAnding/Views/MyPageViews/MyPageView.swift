//
//  MyPageView.swift
//  HappyAnding
//
//  Created by 이지원 on 2022/10/19.
//

import SwiftUI

struct MyPageView: View {
    
    @State var userInformation: User? = nil

    let firebase = FirebaseService()
    
    var userName: String
    var userEmail: String
    
//    var userShortcuts = Shortcut.fetchData(number: 5)
//    var userCurations = UserCuration.fetchData(number: 10)
    
    @State var shortcutsByUser: [Shortcuts] = []
    @State var curationsByUser: [Curation] = []
    @State var likedShortcuts: [Shortcuts] = []
    @State var downloadedShortcuts: [Shortcuts] = []
    
    var body: some View {
        NavigationView {
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
                                Text(userInformation?.nickname ?? "사용자")
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
                    
                    MyShortcutCardListView(shortcuts: shortcutsByUser)
                    UserCurationListView(userCurations: curationsByUser)
                        .frame(maxWidth: .infinity)
                    MyPageShortcutList(
                        shortcuts: likedShortcuts,
                        type: .myLovingShortcut
                    )
                    MyPageShortcutList(
                        shortcuts: downloadedShortcuts,
                        type: .myDownloadShortcut
                    )
                    .padding(.bottom, 44)
                    
                }
            }
            .navigationTitle("프로필")
            .toolbar {
                ToolbarItem {
                    //TODO: 스프린트 1에서 배제 추후 주석 삭제할 것
//                    NavigationLink(destination: SettingView()) {
//                        Image(systemName: "gearshape.fill")
//                            .Headline()
//                            .foregroundColor(.Gray5)
//                    }
                }
            }
            .scrollIndicators(.hidden)
            .background(Color.Background)
        }
        .onAppear {
            firebase.fetchUser(userID: firebase.currentUser()) { user in
                userInformation = user
            }
            firebase.fetchShortcutByIds(shortcutIds: userInformation?.likedShortcuts ?? []) { shortcuts in
                likedShortcuts = shortcuts
            }
            firebase.fetchShortcutByIds(shortcutIds: userInformation?.downloadedShortcuts ?? []) { shortcuts in
                downloadedShortcuts = shortcuts
            }
            firebase.fetchShortcutByAuthor(author: firebase.currentUser()) { shortcuts in
                shortcutsByUser = shortcuts
            }
            firebase.fetchCurationByAuthor(author: firebase.currentUser()) { curations in
                curationsByUser = curations
            }
        }
    }
}

struct MyPageShortcutList: View {
    var shortcuts: [Shortcuts]?
    var type: SectionType
    var body: some View {
        VStack(spacing: 0) {
            MyPageListHeader(type: type, shortcuts: shortcuts)
                .padding(.horizontal, 16)
            if let shortcuts {
                ForEach(Array(shortcuts.enumerated()), id: \.offset) { index, shortcut in
                    if index < 3 {
                        NavigationLink(destination: ReadShortcutView(shortcut: shortcut)) {
//                            ShortcutCell(color: shortcut.color,
//                                         sfSymbol: shortcut.sfSymbol,
//                                         name: shortcut.title,
//                                         description: shortcut.description,
//                                         numberOfDownload: shortcut.numberOfDownload,
//                                         downloadLink: shortcut.downloadLink[shortcut.downloadLink.count - 1]
//                            )
                            ShortcutCell(shortcut: shortcut)
                        }
                    }
                }
            }
        }
    }
}

struct MyPageListHeader: View {
    var type: SectionType
    let shortcuts: [Shortcuts]?
    var body: some View {
        HStack(alignment: .bottom) {
            Text(type.rawValue)
                .Title2()
                .foregroundColor(.Gray5)
                .onTapGesture { }
            Spacer()
            NavigationLink(destination: ListShortcutView(shortcuts: shortcuts, sectionType: type)) {
                Text("더보기")
                    .Footnote()
                    .foregroundColor(.Gray4)
            }
        }
    }
}

struct MyPageView_Previews: PreviewProvider {
    static var previews: some View {
        MyPageView(userName: "롬희", userEmail: "appleid@pos.idserve.net")
    }
}
