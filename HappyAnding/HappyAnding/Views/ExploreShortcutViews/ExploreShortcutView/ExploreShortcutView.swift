//
//  ExploreShortcutView.swift
//  HappyAnding
//
//  Created by 이지원 on 2022/10/19.
//

import SwiftUI

struct ExploreShortcutView: View {
    
    @EnvironmentObject var shortcutsZipViewModel: ShortcutsZipViewModel
    @StateObject var navigation = ShortcutNavigation()
    
    enum NavigationSearch: Hashable, Equatable {
        case first
    }
    
    var body: some View {
        NavigationStack(path: $navigation.shortcutPath) {
            ScrollView {
                MyShortcutCardListView(shortcuts: shortcutsZipViewModel.shortcutsMadeByUser,
                                       navigationParentView: .shortcuts)
                    .padding(.top, 20)
                    .padding(.bottom, 32)
                DownloadRankView(shortcuts: $shortcutsZipViewModel.sortedShortcutsByDownload,
                                 navigationParentView: .shortcuts)
                    .padding(.bottom, 32)
                
                CategoryView()
                    .padding(.bottom, 32)
                LovedShortcutView(shortcuts: $shortcutsZipViewModel.sortedShortcutsByLike)
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
                    .navigationDestination(for: NavigationSearch.self) { _ in
                        SearchView()
                    }
                }
            }
        }
        .environmentObject(navigation)
    }
}

struct ExploreShortcutView_Previews: PreviewProvider {
    static var previews: some View {
        ExploreShortcutView()
    }
}

