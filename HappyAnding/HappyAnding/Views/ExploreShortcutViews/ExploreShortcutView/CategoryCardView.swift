//
//  CategoryCardView.swift
//  HappyAnding
//
//  Created by kimjimin on 2022/11/22.
//

import SwiftUI

struct CategoryCardView: View {
    
    @EnvironmentObject var shortcutsZipViewModel: ShortcutsZipViewModel
    @Binding var shortcuts: [Shortcuts]
    let categoryName: Category
    let navigationParentView: NavigationParentView
    
    var body: some View {
        VStack(spacing: 0) {
            HStack {
                Text(categoryName.translateName())
                    .Title2()
                    .foregroundColor(Color.Gray5)
                    .frame(maxWidth: .infinity, alignment: .leading)
                
                Spacer()
                
                NavigationLink(value: categoryName) {
                    Text("더보기")
                        .Footnote()
                        .foregroundColor(Color.Gray4)
                        .padding(.trailing, 16)
                }
            }
            .padding(.leading, 16)
            .padding(.bottom, 12)
            
            ScrollView(.horizontal, showsIndicators: false) {
                HStack {
                    if let shortcuts {
                        ForEach(Array((shortcuts.enumerated())), id: \.offset) { index, shortcut in
                            if index < 7 {
                                let data = NavigationReadShortcutType(shortcutID: shortcut.id,
                                                                      navigationParentView: self.navigationParentView)
                                
                                NavigationLink(value: data) {
                                    ShortcutCardCell(categoryShortcutIcon: shortcut.sfSymbol,
                                                     categoryShortcutName: shortcut.title,
                                                     categoryShortcutColor: shortcut.color)
                                }
                            }
                        }
                    }
                }
                .padding(.horizontal, 16)
            }
        }
        .navigationDestination(for: Category.self) { category in
            ShortcutsListView(shortcuts: $shortcutsZipViewModel.shortcutsInCategory[category.index],
                              categoryName: category,
                              navigationParentView: .shortcuts)
        }
        .navigationDestination(for: NavigationReadShortcutType.self) { data in
            ReadShortcutView(data: data)
        }
    }
}

//struct CategoryCardView_Previews: PreviewProvider {
//    static var previews: some View {
//        CategoryCardView()
//    }
//}
