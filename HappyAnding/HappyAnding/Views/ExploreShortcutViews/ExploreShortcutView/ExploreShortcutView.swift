//
//  ExploreShortcutView.swift
//  HappyAnding
//
//  Created by 이지원 on 2022/10/19.
//

import SwiftUI

struct ExploreShortcutView: View {
    
    // TODO: firebase는 UserInfo 관련 ViewModel 작성시 지워질 객체
    let firebase = FirebaseService()
    
    @State var shortcutByUser: [Shortcuts] = []
    
    @EnvironmentObject var shortcutsZipViewModel: ShortcutsZipViewModel
    
    var body: some View {
        NavigationView {
            ScrollView {
                MyShortcutCardListView(
                    shortcuts: shortcutByUser)
                    .padding(.top, 20)
                    .padding(.bottom, 32)
                DownloadRankView(shortcuts: shortcutsZipViewModel.sortedShortcutsByDownload())
                    .padding(.bottom, 32)
                CategoryView(shortcuts: shortcutsZipViewModel.sortedShortcutsByDownload())
                    .padding(.bottom, 32)
                LovedShortcutView(shortcuts: shortcutsZipViewModel.sortedshortcutsByLike())
                    .padding(.bottom, 44)
            }
            .navigationTitle(Text("단축어 둘러보기"))
            .background(Color.Background)
        }
        .onAppear() {
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
