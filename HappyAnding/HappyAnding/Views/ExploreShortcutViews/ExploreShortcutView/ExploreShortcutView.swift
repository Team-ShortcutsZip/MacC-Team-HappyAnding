//
//  ExploreShortcutView.swift
//  HappyAnding
//
//  Created by 이지원 on 2022/10/19.
//

import SwiftUI

struct ExploreShortcutView: View {
    let firebase = FirebaseService()
    @State var shortcutsDownloadArray: [Shortcuts] = []
    @State var shortcutLikedArray: [Shortcuts] = []
    @State var userInformation: User? = nil
    
    var body: some View {
        NavigationView {
            ScrollView {
                MyShortcutCardListView(shortcuts: userInformation?.myShortcuts?.sorted(by: { $0.date > $1.date }) ?? nil)
                    .padding(.top, 20)
                    .padding(.bottom, 32)
                DownloadRankView(shortcuts: shortcutsDownloadArray)
                    .padding(.bottom, 32)
                CategoryView(shortcuts: shortcutsDownloadArray)
                    .padding(.bottom, 32)
                LovedShortcutView(shortcuts: shortcutLikedArray)
                    .padding(.bottom, 44)
            }
            .navigationTitle(Text("단축어 둘러보기"))
            .background(Color.Background)
        }
        .onAppear() {
            firebase.fetchAllDownloadShortcut(orderBy: "numberOfDownload") { shortcuts in
                shortcutsDownloadArray = shortcuts
            }
            firebase.fetchAllDownloadShortcut(orderBy: "numberOfLike") { shortcuts in
                shortcutLikedArray = shortcuts
            }
            firebase.fetchUserShortcut(userID: "6466A6C2-DB18-4274-B9C7-9F1EE0C79288") { user in
                userInformation = user
                print(user.myShortcuts?.sorted(by: { $0.date > $1.date }) as Any)
            }
        }
    }
}

struct ExploreShortcutView_Previews: PreviewProvider {
    static var previews: some View {
        ExploreShortcutView()
    }
}
