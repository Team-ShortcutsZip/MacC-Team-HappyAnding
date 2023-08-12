//
//  ListCategoryShortcutView.swift
//  HappyAnding
//
//  Created by KiWoong Hong on 2022/11/05.
//

import SwiftUI

struct ListCategoryShortcutView: View {
    
    @StateObject var viewModel: ListCategoryShortcutViewModel
    
    var body: some View {
        
        ScrollView {
            
            categoryHeader
            
            LazyVStack(spacing: 0) {
                ForEach(viewModel.shortcuts, id: \.self) { shortcut in
                    
                    ShortcutCell(shortcut: shortcut, navigationParentView: .shortcuts)
                        .navigationLinkRouter(data: shortcut)
                        .listRowInsets(EdgeInsets())
                        .listRowSeparator(.hidden)
                                                          
                }
            }
            .padding(.bottom, 44)
        }
        .navigationBarTitle(viewModel.category.translateName())
        .navigationBarTitleDisplayMode(.inline)
        .background(Color.shortcutsZipBackground)
        .navigationBarBackground ({ Color.shortcutsZipBackground })
    }
    
    var categoryHeader: some View {
        Text(viewModel.category.fetchDescription().lineBreaking)
        .foregroundColor(.gray5)
        .shortcutsZipBody2()
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
