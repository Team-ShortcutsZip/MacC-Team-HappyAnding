//
//  ExploreShortcutView.swift
//  HappyAnding
//
//  Created by 이지원 on 2022/10/19.
//

import SwiftUI

struct ExploreShortcutView: View {
    var body: some View {
        NavigationView {
            
            ScrollView {
                MyShortcutCardListView()
                DownloadRankView()
                CategoryView()
                LovedShortcutView()
            }
            .navigationTitle("단축어 둘러보기")
        }
    }
}

struct ExploreShortcutView_Previews: PreviewProvider {
    static var previews: some View {
        ExploreShortcutView()
    }
}
