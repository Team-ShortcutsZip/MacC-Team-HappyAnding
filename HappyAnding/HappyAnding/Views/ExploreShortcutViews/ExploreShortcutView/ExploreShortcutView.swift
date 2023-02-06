//
//  ExploreShortcutView.swift
//  HappyAnding
//
//  Created by 이지원 on 2022/10/19.
//

import SwiftUI

struct ExploreShortcutView: View {
    @EnvironmentObject var shortcutsZipViewModel: ShortcutsZipViewModel
    
    @Binding var isFolded: Bool
    let randomCategories: [Category]
    
    var body: some View {
        ScrollView {
            RecentRegisteredView(shortcuts: $shortcutsZipViewModel.allShortcuts,
                                 navigationParentView: .shortcuts)
            .padding(.top, 20)
            .padding(.bottom, 24)
            
            CategoryCardView(shortcuts: $shortcutsZipViewModel.shortcutsInCategory[randomCategories[0].index],
                             categoryName: randomCategories[0],
                             navigationParentView: .shortcuts)
            .padding(.bottom, 24)

            DownloadRankView(shortcuts: $shortcutsZipViewModel.sortedShortcutsByDownload,
                             navigationParentView: .shortcuts)
            .padding(.bottom, 24)
            
            CategoryCardView(shortcuts: $shortcutsZipViewModel.shortcutsInCategory[randomCategories[1].index],
                             categoryName: randomCategories[1],
                             navigationParentView: .shortcuts)
            .padding(.bottom, 24)
            
            LovedShortcutView(shortcuts: $shortcutsZipViewModel.sortedShortcutsByLike)
                .padding(.bottom, 24)
            
            CategoryView(isFolded: $isFolded)
                .padding(.bottom, 44)
        }
        .scrollIndicators(.hidden)
        .navigationBarTitle(TextLiteral.exploreShortcutViewTitle)
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
        ExploreShortcutView(isFolded: .constant(true), randomCategories: [Category.lifestyle, Category.utility])
    }
}

