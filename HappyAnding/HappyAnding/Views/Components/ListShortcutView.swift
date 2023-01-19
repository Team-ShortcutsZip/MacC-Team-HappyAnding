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
    @State var shortcutsArray: [Shortcuts] = []
    @State private var isLastItem = false
    
    var body: some View {
        if let shortcuts = data.shortcuts {
            if shortcuts.count == 0 {
                Text("\(data.sectionType.rawValue)가 없습니다.")
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
                        ForEach(Array(shortcuts.enumerated()), id: \.offset) { index, shortcut in
                            let navigationData = NavigationReadShortcutType(shortcut: shortcut,
                                                                            shortcutID: shortcut.id,
                                                                            navigationParentView: self.data.navigationParentView)
                            
                            NavigationLink(value: navigationData) {
                                if data.sectionType == .download && index < 100 {
                                    ShortcutCell(shortcut: shortcut,
                                                 rankNumber: index + 1,
                                                 navigationParentView: data.navigationParentView)
                                    .listRowInsets(EdgeInsets())
                                    .listRowSeparator(.hidden)
                                } else {
                                    ShortcutCell(shortcut: shortcut,
                                                 navigationParentView: data.navigationParentView,
                                                 sectionType: data.sectionType)
                                    .listRowInsets(EdgeInsets())
                                    .listRowSeparator(.hidden)
                                }
                            }
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
}
