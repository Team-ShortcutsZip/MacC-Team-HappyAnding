//
//  ExploreShortcutView.swift
//  HappyAnding
//
//  Created by 이지원 on 2022/10/19.
//

import SwiftUI

struct ExploreShortcutView: View {
    
    @EnvironmentObject var shortcutsZipViewModel: ShortcutsZipViewModel
    
    @AppStorage("isAnnouncementShow") var isAnnouncementShow: Bool = false
//    @AppStorage("isUpdateAnnnouncementShow") var isUpdateAnnnouncementShow: Bool = true
    
    @Binding var isFolded: Bool
    
    @State var isTappedUserGradeButton = false
    
    let randomCategories: [Category]
    
    var body: some View {
        ScrollView {
            VStack(spacing: 32) {
                if isAnnouncementShow {
                    Button {
                        isTappedUserGradeButton = true
                    } label: {
                        AnnouncementCell(icon: "ShortcutGradeAnnouncement",
                                         tagName: TextLiteral.newFeatureTag,
                                         discription: TextLiteral.shortcutGradeDescription,
                                         isAnnouncementShow: $isAnnouncementShow)
                    }
                    .id(000)
                }
                
                RecentRegisteredView(shortcuts: $shortcutsZipViewModel.allShortcuts,
                                     navigationParentView: .shortcuts)
                
                CategoryCardView(shortcuts: $shortcutsZipViewModel.shortcutsInCategory[randomCategories[0].index],
                                 categoryName: randomCategories[0],
                                 navigationParentView: .shortcuts)

                DownloadRankView(shortcuts: $shortcutsZipViewModel.sortedShortcutsByDownload,
                                 navigationParentView: .shortcuts)
                
                CategoryCardView(shortcuts: $shortcutsZipViewModel.shortcutsInCategory[randomCategories[1].index],
                                 categoryName: randomCategories[1],
                                 navigationParentView: .shortcuts)
                
                LovedShortcutView(shortcuts: $shortcutsZipViewModel.sortedShortcutsByLike)
                
                CategoryView(isFolded: $isFolded)
            }
            .padding(.top, 20)
            .padding(.bottom, 44)
        }
        .scrollIndicators(.hidden)
        .navigationBarTitle(TextLiteral.exploreShortcutViewTitle)
        .navigationBarTitleDisplayMode(.large)
        .background(Color.shortcutsZipBackground)
        .toolbar {
            ToolbarItem {
                Image(systemName: "magnifyingglass")
                    .shortcutsZipHeadline()
                    .foregroundColor(.gray5)
                    .navigationLinkRouter(data: NavigationSearch.first)
            }
        }
        .navigationBarBackground ({ Color.shortcutsZipBackground })
        .sheet(isPresented: $isTappedUserGradeButton) {
            AboutShortcutGradeView()
                .presentationDetents([.large])
                .presentationDragIndicator(.visible)
        }
    }
}

struct ExploreShortcutView_Previews: PreviewProvider {
    static var previews: some View {
        ExploreShortcutView(isFolded: .constant(true), randomCategories: [Category.lifestyle, Category.utility])
    }
}

