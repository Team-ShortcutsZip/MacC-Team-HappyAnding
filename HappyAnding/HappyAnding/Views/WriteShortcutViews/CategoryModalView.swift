//
//  CategoryModalView.swift
//  HappyAnding
//
//  Created by 이지원 on 2022/10/19.
//

import SwiftUI

struct CategoryModalView: View {
    @Binding var isShowingCategoryModal: Bool
    @Binding var selectedCategories: [String]
    
    private let gridLayout = [GridItem(.flexible()), GridItem(.flexible())]
    
    var body: some View {
        ZStack {
            Color.Background
                .ignoresSafeArea()
            VStack {
                HStack(spacing: 0) {
                    Button {
                        self.isShowingCategoryModal = false
                    } label: {
                        Text(TextLiteral.close)
                            .foregroundColor(.Gray5)
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .padding(.leading, 16)
                    }
                    
                    Text(TextLiteral.categoryTitle)
                        .font(.headline)
                        .frame(maxWidth: .infinity)
                    
                    Spacer()
                        .frame(maxWidth: .infinity)
                }
                
                Spacer()
                    .frame(height: UIScreen.main.bounds.size.height * 0.7 * 0.04)
                
                LazyVGrid(columns: gridLayout, spacing: 12) {
                    ForEach(Category.allCases, id: \.self) { item in
                        CategoryButton(item: item, items: $selectedCategories)
                    }
                }
                .padding(.horizontal, 16)
                
                Spacer()
                    .frame(height: UIScreen.main.bounds.size.height * 0.7 * 0.04)
                
                Button(action: {
                    isShowingCategoryModal = false
                }, label: {
                    ZStack {
                        RoundedRectangle(cornerRadius: 12)
                            .foregroundColor(!selectedCategories.isEmpty ? .Primary : .Primary .opacity(0.13) )
                            .frame(maxWidth: .infinity, maxHeight: 52)
                        
                        Text(TextLiteral.done)
                            .foregroundColor(!selectedCategories.isEmpty ? .Text_icon : .Text_Button_Disable)
                            .Body1()
                    }
                })
                .disabled(selectedCategories.isEmpty)
                .padding(.horizontal, 16)
            }
        }
    }
    
    struct CategoryButton: View {
        let item: Category
        @Binding var items: [String]
        
        var body: some View {
            Button(action: {
                if items.contains(item.category) {
                    items.removeAll { $0 == item.category }
                } else {
                    if items.count < 3 {
                        items.append(item.category)
                    }
                }
            }, label: {
                Text(item.translateName())
                    .Body2()
                    .tag(item.category)
                    .foregroundColor(items.contains(item.category) ? Color.Category_Pick_Text : Color.Gray3)
                    .frame(maxWidth: .infinity, minHeight: UIScreen.main.bounds.size.height * 0.7 * 0.08)
                    .background(
                        RoundedRectangle(cornerRadius: 12)
                            .fill(items.contains(item.category) ? Color.Category_Pick_Fill : .clear)
                            .overlay(
                                RoundedRectangle(cornerRadius: 12)
                                    .strokeBorder(items.contains(item.category) ? Color.Primary : Color.Gray3, lineWidth: 1)
                            )
                    )
                
            })
        }
    }
}

struct CategoryModalView_Previews: PreviewProvider {
    static var previews: some View {
        CategoryModalView(isShowingCategoryModal: .constant(true), selectedCategories: .constant(["finance"]))
    }
}
