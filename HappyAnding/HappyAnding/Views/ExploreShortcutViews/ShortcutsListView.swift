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
    
    var categoryName: Category?
    var sectionType: SectionType?
    
    var body: some View {
        ScrollView {
            
            scrollHeader
            
            LazyVStack {
                ForEach(Array(shortcuts.enumerated()), id: \.offset) { index, shortcut in
                    NavigationLink(destination: ReadShortcutView(shortcut: shortcut,
                                                                 shortcutID: shortcut.id)) {
                        ShortcutCell(shortcut: shortcut,
                                     rankNumber: sectionType == .download ? index + 1 : -1)
                        
                        .listRowInsets(EdgeInsets())
                        .listRowSeparator(.hidden)
                        .onAppear {
                            if shortcuts.count-1 == index && !isLastShortcut {
                                if let categoryName = self.categoryName {
                                    self.shortcutsZipViewModel.fetchCategoryShortcutLimit(category: categoryName, orderBy: "date") { newShortcuts in
                                        if Set(newShortcuts).intersection(Set(shortcuts)) == [] {
                                            self.shortcuts.append(contentsOf: newShortcuts)
                                        }
                                        else {
                                            isLastShortcut = true
                                        }
                                    }
                                }
                                // TODO: sectionType에 따라서 요청함수 다르거 해줘야 함
                                switch self.sectionType {
                                case .download:
                                    shortcutsZipViewModel.fetchShortcutLimit(orderBy: "numberOfDownload") { newShortcuts in
                                        if Set(newShortcuts).intersection(Set(shortcuts)) == [] {
                                            self.shortcuts.append(contentsOf: newShortcuts)
                                        }
                                        else {
                                            isLastShortcut = true
                                        }
                                    }
                                case .popular:
                                    shortcutsZipViewModel.fetchShortcutLimit(orderBy: "numberOfLike") { newShortcuts in
                                        if Set(newShortcuts).intersection(Set(shortcuts)) == [] {
                                            self.shortcuts.append(contentsOf: newShortcuts)
                                        }
                                        else {
                                            isLastShortcut = true
                                        }
                                    }
                                default: break
                                }
                            }
                        }
                    }
                    .navigationDestination(for: String.self) { shortcutID in
                        ReadShortcutView(shortcut: shortcut,
                                         shortcutID: shortcutID)
                    }
                }
            }
        }
        .navigationBarTitle((categoryName == nil ? sectionType?.rawValue : categoryName?.translateName())!)
        .navigationBarTitleDisplayMode(.inline)
        .background(Color.Background)
        .onAppear {
            if let categoryName = self.categoryName {
                if shortcutsZipViewModel.isFirstFetchInCategory[categoryName.index] {
                    self.shortcutsZipViewModel.fetchCategoryShortcutLimit(category: categoryName, orderBy: "date") { newShortcuts in
                        self.shortcuts.append(contentsOf: newShortcuts)
                    }
                    shortcutsZipViewModel.isFirstFetchInCategory[categoryName.index] = false
                }
            }
        }
    }
    
    var scrollHeader: some View {
        VStack {
            if let categoryName {
                Text(categoryName.fetchDescription())
            } else {
                if let sectionType {
                    Text(sectionType.description)
                }
            }
        }
        .foregroundColor(.Gray5)
        .Body2()
        .padding(16)
        .frame(maxWidth: .infinity, alignment: sectionType == .download ? .center : .leading)
        .background(
            Rectangle()
                .foregroundColor(Color.Gray1)
                .cornerRadius(12)
        )
        .padding(.vertical, 20)
        .padding(.horizontal, 16)
    }
}
