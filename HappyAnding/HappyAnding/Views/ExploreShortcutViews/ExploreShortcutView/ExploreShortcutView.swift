//
//  ExploreShortcutView.swift
//  HappyAnding
//
//  Created by 이지원 on 2022/10/19.
//

import SwiftUI

struct ExploreShortcutView: View {
    
    @EnvironmentObject var shortcutsZipViewModel: ShortcutsZipViewModel
    
    var body: some View {
        NavigationView {
            ScrollView {
                MyShortcutCardListView(
                    shortcuts: shortcutsZipViewModel.shortcutsMadeByUser)
                    .padding(.top, 20)
                    .padding(.bottom, 32)
                DownloadRankView(shortcuts: shortcutsZipViewModel.sortedShortcutsByDownload)
                    .padding(.bottom, 32)
                CategoryView(shortcuts: shortcutsZipViewModel.sortedShortcutsByDownload)
                    .padding(.bottom, 32)
                LovedShortcutView(shortcuts: shortcutsZipViewModel.sortedShortcutsByDownload)
                    .padding(.bottom, 44)
            }
            .navigationTitle(Text("단축어 둘러보기"))
            .background(Color.Background)
        }
    }
}

struct ExploreShortcutView_Previews: PreviewProvider {
    static var previews: some View {
        ExploreShortcutView()
    }
}
