//
//  ListShortcutView.swift
//  HappyAnding
//
//  Created by 이지원 on 2022/10/20.
//

import SwiftUI

/// - parameters:
/// sectionType: 다운로드 순위에서 접근할 시, .download를, 사랑받는 앱에서 접근시 .popular를 넣어주세요.
struct ListShortcutView: View {
    
    @EnvironmentObject var shortcutsZipViewModel: ShortcutsZipViewModel
    
    @State var data: NavigationListShortcutType
    @State private var isLastItem = false
    
    var body: some View {
        if let shortcuts = data.shortcuts {
            if shortcuts.count == 0 {
                Text("아직 \(data.sectionType.rawValue)가 없어요")
                    .Body2()
                    .foregroundColor(Color.Gray4)
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                
                    .background(Color.Background.ignoresSafeArea(.all, edges: .all))
                    .navigationTitle(data.sectionType.rawValue)
                    .navigationBarTitleDisplayMode(.inline)
            } else {
                ScrollView {
                    LazyVStack(spacing: 0) {
                        
                        //TODO: 무한 스크롤을 위한 업데이트 함수 필요
                        switch data.sectionType {
                        case .recent:
                            makeShortcutCellList(shortcutsZipViewModel.allShortcuts)
                        case .download:
                            makeIndexShortcutCellList(shortcutsZipViewModel.sortedShortcutsByDownload)
                        case .popular:
                            makeShortcutCellList(shortcutsZipViewModel.sortedShortcutsByLike)
                        case .myDownloadShortcut:
                            makeShortcutCellList(shortcutsZipViewModel.shortcutsUserDownloaded)
                        case .myLovingShortcut:
                            makeShortcutCellList(shortcutsZipViewModel.shortcutsUserLiked)
                        case .myShortcut:
                            makeShortcutCellList(shortcutsZipViewModel.shortcutsMadeByUser)
                        }
                        Rectangle()
                            .fill(Color.Background)
                            .frame(height: 44)
                            .listRowInsets(EdgeInsets())
                            .listRowSeparator(.hidden)
                    }
                }
                .listRowBackground(Color.Background)
                .listStyle(.plain)
                .background(Color.Background.ignoresSafeArea(.all, edges: .all))
                .scrollContentBackground(.hidden)
                .navigationTitle(data.sectionType.rawValue)
                .navigationBarTitleDisplayMode(.inline)
                .navigationBarBackground ({ Color.Background })
            }
        }
    }
    
    @ViewBuilder
    private func makeShortcutCellList(_ shortcuts: [Shortcuts]) -> some View {
        ForEach(shortcuts, id: \.self) { shortcut in
            let navigationData = NavigationReadShortcutType(shortcut: shortcut,
                                                            shortcutID: shortcut.id,
                                                            navigationParentView: self.data.navigationParentView)

            NavigationLink(value: navigationData) {
                ShortcutCell(shortcut: shortcut,
                             navigationParentView: data.navigationParentView,
                             sectionType: data.sectionType)
                .listRowInsets(EdgeInsets())
                .listRowSeparator(.hidden)
            }
        }
    }
    
    @ViewBuilder
    private func makeIndexShortcutCellList(_ shortcuts: [Shortcuts]) -> some View {
        ForEach(Array(shortcuts.enumerated()), id: \.offset) { index, shortcut in
            let navigationData = NavigationReadShortcutType(shortcut: shortcut,
                                                            shortcutID: shortcut.id,
                                                            navigationParentView: self.data.navigationParentView)
            
            NavigationLink(value: navigationData) {
                ShortcutCell(shortcut: shortcut,
                             rankNumber: index + 1,
                             navigationParentView: data.navigationParentView)
                .listRowInsets(EdgeInsets())
                .listRowSeparator(.hidden)
            }
        }
    }
}
