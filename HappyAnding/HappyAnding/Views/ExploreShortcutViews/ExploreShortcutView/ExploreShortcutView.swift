//
//  ExploreShortcutView.swift
//  HappyAnding
//
//  Created by 이지원 on 2022/10/19.
//

import SwiftUI

struct ExploreShortcutView: View {
    
    @EnvironmentObject var shortcutsZipViewModel: ShortcutsZipViewModel
    let randomCategories: [Category]
    
    var body: some View {
        ScrollView {
            DownloadRankView(shortcuts: $shortcutsZipViewModel.sortedShortcutsByDownload,
                             navigationParentView: .shortcuts)
            .padding(.top, 20)
            .padding(.bottom, 24)
            
            CategoryCardView(shortcuts: $shortcutsZipViewModel.shortcutsInCategory[randomCategories[0].index],
                             categoryName: randomCategories[0],
                             navigationParentView: .shortcuts)
            .padding(.bottom, 24)
            
            LovedShortcutView(shortcuts: $shortcutsZipViewModel.sortedShortcutsByLike)
                .padding(.bottom, 24)
            
            CategoryCardView(shortcuts: $shortcutsZipViewModel.shortcutsInCategory[randomCategories[1].index],
                             categoryName: randomCategories[1],
                             navigationParentView: .shortcuts)
            .padding(.bottom, 24)
            
            CategoryView()
                .padding(.bottom, 44)
        }
        .scrollIndicators(.hidden)
        .navigationBarTitle(Text("단축어 둘러보기"))
        .navigationBarTitleDisplayMode(.large)
        .background(Color.Background)
        .toolbar {
            ToolbarItem {
                NavigationLink(value: NavigationSearch.first) {
                    Image(systemName: "magnifyingglass")
                        .Headline()
                        .foregroundColor(.Gray5)
                }
            }
        }
        .navigationBarBackground ({ Color.Background })
    }
}

struct ExploreShortcutView_Previews: PreviewProvider {
    static var previews: some View {
        ExploreShortcutView(randomCategories: [Category.lifestyle, Category.utility])
    }
}

