//
//  ExploreShortcutView.swift
//  HappyAnding
//
//  Created by 이지원 on 2022/10/19.
//

import SwiftUI

struct ExploreShortcutView: View {
    let firebase = FirebaseService()
    @State var shortcutsArray: [Shortcuts] = []
    var body: some View {
        NavigationView {
            ScrollView {
                MyShortcutCardListView()
                    .padding(.top, 20)
                    .padding(.bottom, 32)
                DownloadRankView(shortcuts: shortcutsArray)
                    .padding(.bottom, 32)
                CategoryView(shortcuts: shortcutsArray)
                    .padding(.bottom, 32)
                LovedShortcutView(shortcuts: shortcutsArray)
                    .padding(.bottom, 44)
            }
            .navigationTitle(Text("단축어 둘러보기"))
            .background(Color.Background)
        }
        .onAppear() {
            firebase.fetchAllDownloadShortcut { shortcuts in
                shortcutsArray = shortcuts
                print(shortcutsArray)
            }
        }
    }
}

struct ExploreShortcutView_Previews: PreviewProvider {
    static var previews: some View {
        ExploreShortcutView()
    }
}
