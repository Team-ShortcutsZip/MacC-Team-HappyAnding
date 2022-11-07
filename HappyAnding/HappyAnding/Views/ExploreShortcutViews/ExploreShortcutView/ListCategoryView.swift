//
//  ListCategoryView.swift
//  HappyAnding
//
//  Created by 이지원 on 2022/10/25.
//

import SwiftUI

struct ListCategoryView: View {
    
    @Binding var shortcuts: [Shortcuts]
    private let gridLayout = [GridItem(.flexible()), GridItem(.flexible())]
    
    var body: some View {
        
        ZStack(alignment: .top) {
            Color.Background
                .ignoresSafeArea()
            
            VStack {
                LazyVGrid(columns: gridLayout, spacing: 0) {
                    ForEach(Category.allCases, id: \.self) { item in
                        NavigationLink(value: shortcuts) {
                            CategoryCellView(categoryName: item.translateName())
                                .padding(.horizontal, 6)
                                .padding(.vertical, 7)
                        }
                        .navigationDestination(for: [Shortcuts].self, destination: { shortcuts in
                            ShortcutsListView(shortcuts: $shortcuts, categoryName: item, sectionType: SectionType.download)
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

//
//struct ListCategoryView_Previews: PreviewProvider {
//    static var previews: some View {
//        ListCategoryView()
//    }
//}
