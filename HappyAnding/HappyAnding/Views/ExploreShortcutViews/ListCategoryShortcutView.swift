//
//  ShortcutsListView.swift
//  HappyAnding
//
//  Created by KiWoong Hong on 2022/11/05.
//

import SwiftUI

struct ListCategoryShortcutView: View {
    
    @EnvironmentObject var shortcutsZipViewModel: ShortcutsZipViewModel
    
    @State var navigationTitle = ""
    @State var isLastShortcut: Bool = false
    @State var data: NavigationListCategoryShortcutType
    
    var body: some View {
        ScrollView {
            
            scrollHeader
            
            LazyVStack(spacing: 0) {
                ForEach(data.shortcuts, id: \.self) { shortcut in
                    let data = NavigationReadShortcutType(shortcut: shortcut,
                                                          shortcutID: shortcut.id,
                                                          navigationParentView: self.data.navigationParentView)
                    ShortcutCell(shortcut: shortcut,
                                 navigationParentView: self.data.navigationParentView)
                    .navigationLinkRouter(data: data)
                    .listRowInsets(EdgeInsets())
                    .listRowSeparator(.hidden)
                }
            }
            .padding(.bottom, 44)
        }
        .navigationBarTitle(data.categoryName.translateName())
        .navigationBarTitleDisplayMode(.inline)
        .background(Color.shortcutsZipBackground)
        .navigationBarBackground ({ Color.shortcutsZipBackground })
        .onAppear {
            self.data.shortcuts = shortcutsZipViewModel.shortcutsInCategory[data.categoryName.index]
        }
    }
    
    var scrollHeader: some View {
        VStack {
            Text(data.categoryName.fetchDescription().lineBreaking)
        }
        .foregroundColor(.gray5)
        .Body2()
        .padding(16)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(
            Rectangle()
                .foregroundColor(Color.gray1)
                .cornerRadius(12)
        )
        .padding(.vertical, 20)
        .padding(.horizontal, 16)
    }
}
