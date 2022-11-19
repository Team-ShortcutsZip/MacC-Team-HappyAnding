//
//  ShortcutsListView.swift
//  HappyAnding
//
//  Created by KiWoong Hong on 2022/11/05.
//

import SwiftUI

struct ShortcutsListView: View {
    
    @EnvironmentObject var shortcutsZipViewModel: ShortcutsZipViewModel
    @Binding var shortcuts:[Shortcuts]
    @State var navigationTitle = ""
    
    @State var isLastShortcut: Bool = false
    
    var categoryName: Category
    let navigationParentView: NavigationParentView
    
    var body: some View {
        ScrollView {
            
            scrollHeader
            
            LazyVStack {
                ForEach(Array(shortcuts.enumerated()), id: \.offset) { index, shortcut in
                    let data = NavigationReadShortcutType(shortcut: shortcut,
                                                          shortcutID: shortcut.id,
                                                          navigationParentView: self.navigationParentView)
                    NavigationLink(value: data) {
                        ShortcutCell(shortcut: shortcut,
                                     navigationParentView: self.navigationParentView)
                        
                        .listRowInsets(EdgeInsets())
                        .listRowSeparator(.hidden)
                        .onAppear {
                            if shortcuts.count-1 == index && !isLastShortcut {
                                self.shortcutsZipViewModel.fetchCategoryShortcutLimit(category: categoryName, orderBy: "date") { newShortcuts in
                                    if Set(newShortcuts).intersection(Set(shortcuts)) == [] {
                                        self.shortcuts.append(contentsOf: newShortcuts)
                                    }
                                    else {
                                        isLastShortcut = true
                                    }
                                }
                            }
                        }
                    }
                }
            }
        }
        .scrollIndicators(.hidden)
        .navigationDestination(for: NavigationReadShortcutType.self) { data in
            ReadShortcutView(data: data)
        }
        .navigationBarTitle(categoryName.translateName())
        .navigationBarTitleDisplayMode(.inline)
        .background(Color.Background)
        .onAppear {
            if shortcutsZipViewModel.isFirstFetchInCategory[categoryName.index] {
                self.shortcutsZipViewModel.fetchCategoryShortcutLimit(category: categoryName, orderBy: "date") { newShortcuts in
                    self.shortcuts.append(contentsOf: newShortcuts)
                }
                shortcutsZipViewModel.isFirstFetchInCategory[categoryName.index] = false
            }
        }
    }
    
    var scrollHeader: some View {
        VStack {
            Text(categoryName.fetchDescription())
        }
        .foregroundColor(.Gray5)
        .Body2()
        .padding(16)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(
            Rectangle()
                .foregroundColor(Color.Gray1)
                .cornerRadius(12)
        )
        .padding(.vertical, 20)
        .padding(.horizontal, 16)
    }
}
