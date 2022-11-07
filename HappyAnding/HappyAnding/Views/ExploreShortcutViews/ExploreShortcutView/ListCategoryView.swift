//
//  ListCategoryView.swift
//  HappyAnding
//
//  Created by 이지원 on 2022/10/25.
//

import SwiftUI

struct ListCategoryView: View {
    
    @EnvironmentObject var shortcutsZipViewModel: ShortcutsZipViewModel
    @Binding var shortcuts: [Shortcuts]
    private let gridLayout = [GridItem(.flexible()), GridItem(.flexible())]
    
    var body: some View {
        
        ZStack(alignment: .top) {
            Color.Background
                .ignoresSafeArea()
            
            VStack {
                LazyVGrid(columns: gridLayout, spacing: 0) {
                    ForEach(Category.allCases, id: \.self) { item in
                        NavigationLink(destination: ShortcutsListView(shortcuts: $shortcuts, categoryName: item)) {
                            RoundedRectangle(cornerSize: CGSize(width: 12, height: 12))
                                .stroke(Color.Gray1, lineWidth: 1)
                                .background(Color.White)
                                .cornerRadius(12)
                                .frame(maxWidth: .infinity, minHeight:48, maxHeight: 48)
                                .overlay {
                                    Text(item.translateName())
                                        .Body2()
                                        .foregroundColor(Color.Gray5)
                                }
                                .padding(.horizontal, 6)
                                .padding(.vertical, 7)
                        }.simultaneousGesture(TapGesture().onEnded {
                            shortcutsZipViewModel.fetchCategoryShortcutLimit(category: item.rawValue, orderBy: "numberOfDownload") { newShortcuts in
                                shortcuts.removeAll()
                                shortcuts.append(contentsOf: newShortcuts)
                            }
                            
                        })
                    }
                }
                .padding(.horizontal, 16)
                .padding(.top, 32)
                Spacer().frame(maxWidth: .infinity)
            }
        }
        .frame(maxHeight: .infinity)
        .navigationBarTitleDisplayMode(.inline)
        .navigationTitle("카테고리")
    }
}

