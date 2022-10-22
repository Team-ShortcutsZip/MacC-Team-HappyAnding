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
                    .padding(.bottom, 32)
                DownloadRankView()
                    .padding(.bottom, 32)
                CategoryView()
                    .padding(.bottom, 32)
                LovedShortcutView()
            }
            .navigationTitle("단축어 둘러보기")
            .background(Color.Background)
        }
    }
}

struct ExploreShortcutView_Previews: PreviewProvider {
    static var previews: some View {
        ExploreShortcutView()
    }
}
