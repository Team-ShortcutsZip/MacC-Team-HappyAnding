//
//  CategoryView.swift
//  HappyAnding
//
//  Created by KiWoong Hong on 2022/10/22.
//

import SwiftUI

struct CategoryView: View {
    
    @EnvironmentObject var navigation: ShortcutNavigation
    @EnvironmentObject var shortcutsZipViewModel: ShortcutsZipViewModel
    @State var categoryIndex = 6
    @State var isTappedPlutButton = true {
        didSet {
            if isTappedPlutButton {
                categoryIndex = 6
            } else {
                categoryIndex = 12
            }
        }
    }
    
    var body: some View {
        VStack {
            HStack {
                Text("카테고리 모아보기")
                    .Title2()
                    .foregroundColor(Color.Gray5)
                    .frame(maxWidth: .infinity, alignment: .leading)
                
                Spacer()
                                
                Button(action: {
                    self.isTappedPlutButton.toggle()
                }, label: {
                    Text(isTappedPlutButton ? "펼치기" : "접기")
                        .Footnote()
                        .foregroundColor(Color.Gray4)
                        .padding(.trailing, 16)
                })
            }
            .padding(.leading, 16)
            LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())]) {
                ForEach(Array(Category.allCases.enumerated()), id: \.offset) { index, value in
                    if index < categoryIndex {
                        NavigationLink(value: value, label: {
                            CategoryCellView(categoryName: value.translateName())
                        })
                        .navigationDestination(for: Category.self) { category in
                            ShortcutsListView(shortcuts: $shortcutsZipViewModel.shortcutsInCategory[category.index],
                                              categoryName: category)
                        }
                    }
                }
            }
            .padding(.horizontal, 16)
        }
        .environmentObject(navigation)
    }
}

struct CategoryCellView: View {
    
    let categoryName: String
    
    var body: some View {
        RoundedRectangle(cornerSize: CGSize(width: 12, height: 12))
            .strokeBorder(Color.Gray1, lineWidth: 1)
            .background(Color.White)
            .cornerRadius(12)
            .frame(maxWidth: .infinity, minHeight:48, maxHeight: 48)
            .overlay {
                Text(categoryName)
                    .Body2()
                    .foregroundColor(Color.Gray5)
            }
    }
}

//struct CategoryView_Previews: PreviewProvider {
//    static var previews: some View {
//        CategoryView()
//    }
//}
