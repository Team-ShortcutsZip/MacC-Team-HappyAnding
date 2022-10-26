//
//  ListCategoryView.swift
//  HappyAnding
//
//  Created by 이지원 on 2022/10/25.
//

import SwiftUI

struct ListCategoryView: View {
    
    private let gridLayout = [GridItem(.flexible()), GridItem(.flexible())]
    
    var body: some View {
        
        ZStack(alignment: .top) {
            Color.Background
                .ignoresSafeArea()
            
            VStack {
                LazyVGrid(columns: gridLayout) {
                    ForEach(Category.allCases, id: \.self) { item in
                        
                        NavigationLink(destination: ExploreCategoryView(category: item)) {
                            
                            Text(item.rawValue)
                                .Body2()
                                .tag(item)
                                .foregroundColor(Color.Gray3)
                                .frame(maxWidth: UIScreen.main.bounds.size.width * 0.5,
                                       minHeight: UIScreen.main.bounds.size.height * 0.7 * 0.09)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 12)
                                        .stroke(Color.Gray3, lineWidth: 1)
                                )
                        }
                        .padding(8)
                    }
                }
                .padding(.horizontal, 8)
                            Spacer().frame(maxWidth: .infinity)
            }
        }
        .frame(maxHeight: .infinity)
        .navigationBarTitleDisplayMode(.inline)
        .navigationTitle("카테고리")
    }
}


struct ListCategoryView_Previews: PreviewProvider {
    static var previews: some View {
        ListCategoryView()
    }
}
