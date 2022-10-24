//
//  CategoryModalView.swift
//  HappyAnding
//
//  Created by 이지원 on 2022/10/19.
//

import SwiftUI

struct CategoryModalView: View {
    private let gridLayout = [GridItem(.flexible()), GridItem(.flexible())]
    @State var selectedCategories: [Category] = []
    
    var body: some View {
        VStack {
            Text("카테고리")
                .font(.headline)
            
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
                
                // TODO: 모달 닫기
                
            }, label: {
                Text("완료")
                    .Body1()
                    .frame(maxWidth: .infinity, minHeight: 52)
            })
            .tint(.Primary)
            .buttonStyle(.borderedProminent)
            .disabled(selectedCategories.isEmpty)
            .padding(.horizontal, 16)
        }
    }
    
    struct CategoryButton: View {
        let item: Category
        @Binding var items: [Category]
        
        var body: some View {
            Button(action: {
                if items.contains(item) {
                    items.removeAll { $0 == item }
                } else {
                    items.append(item)
                }
            }, label: {
                Text(item.rawValue)
                    .Body2()
                    .tag(item)
                    .foregroundColor(items.contains(item) ? Color.Primary : Color.Gray3)
                    .frame(maxWidth: .infinity, minHeight: UIScreen.main.bounds.size.height * 0.7 * 0.08)
                    .overlay(
                        RoundedRectangle(cornerRadius: 12)
                            .stroke(items.contains(item) ? Color.Primary : Color.Gray3, lineWidth: 1)
                    )
            })
        }
    }
}

struct CategoryModalView_Previews: PreviewProvider {
    static var previews: some View {
        CategoryModalView()
    }
}
