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
//    @State var userInformation: User? = nil
    @State var shortcutByUser: [Shortcuts] = []
    
    var body: some View {
        NavigationView {
            ScrollView {
                MyShortcutCardListView(
                    shortcuts: shortcutByUser)
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
            firebase.fetchShortcutByAuthor(author: "testUser") { user in
                shortcutByUser = user
            }
        }
    }
}

struct ExploreShortcutView_Previews: PreviewProvider {
    static var previews: some View {
        ExploreShortcutView()
    }
}
