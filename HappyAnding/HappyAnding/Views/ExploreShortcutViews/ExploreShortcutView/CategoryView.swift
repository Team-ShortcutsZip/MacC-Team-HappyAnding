//
//  CategoryView.swift
//  HappyAnding
//
//  Created by KiWoong Hong on 2022/10/22.
//

import SwiftUI

struct CategoryView: View {
    
    @EnvironmentObject var shortcutsZipViewModel: ShortcutsZipViewModel
    
    @Binding var isFolded: Bool
    @State var categoryIndex = 6
    
    var body: some View {
        VStack {
            HStack {
                SubtitleTextView(text: TextLiteral.categoryViewTitle)
                
                Spacer()
                                
                Button(action: {
                    self.isFolded.toggle()
                }, label: {
                    MoreCaptionTextView(text: isFolded ? TextLiteral.categoryViewUnfold : TextLiteral.categoryViewFold)
                })
                .onChange(of: isFolded) { _ in
                    categoryIndex = isFolded ? 6 : 12
                }
            }
            .padding(.horizontal, 16)
            
            LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())]) {
                ForEach(Array(Category.allCases.enumerated()), id: \.offset) { index, value in
                    
                    let data = NavigationListCategoryShortcutType(shortcuts: [],
                                                                  categoryName: value,
                                                                  navigationParentView: .shortcuts)
                    
                    if index < categoryIndex {
                        
                        CategoryCellView(categoryName: value.translateName())
                            .navigationLinkRouter(data: data)
                        
                    }
                }
            }
            .padding(.horizontal, 16)
            .padding(.bottom, 16)
            .id(999)
        }
    }
}

struct CategoryCellView: View {
    
    let categoryName: String
    
    var body: some View {
        RoundedRectangle(cornerSize: CGSize(width: 12, height: 12))
            .strokeBorder(Color.gray1, lineWidth: 1)
            .background(Color.shortcutsZipWhite)
            .cornerRadius(12)
            .frame(maxWidth: .infinity, minHeight:48, maxHeight: 48)
            .overlay {
                Text(categoryName)
                    .Body2()
                    .foregroundColor(Color.gray5)
            }
    }
}
